const {onSchedule} = require("firebase-functions/v2/scheduler");
const {onValueCreated} = require("firebase-functions/v2/database");
const {initializeApp} = require("firebase-admin/app");
const {getAuth} = require("firebase-admin/auth");
const {getFirestore} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

initializeApp();

// Matches UserRole.ADMIN.value in lib/common/enums/user_role.dart.
const ADMIN_ROLE_VALUE = 1;
const NOTIFICATION_BODY_MAX_LENGTH = 200;

// Anonymous accounts inactive longer than this are considered stale.
const STALE_AFTER_DAYS = 30;
const LIST_USERS_PAGE_SIZE = 1000;
const FIRESTORE_BATCH_LIMIT = 500;

function chunk(array, size) {
  const chunks = [];
  for (let i = 0; i < array.length; i += size) {
    chunks.push(array.slice(i, i + size));
  }
  return chunks;
}

async function deleteFirestoreUserDocs(firestore, uids) {
  for (const batchUids of chunk(uids, FIRESTORE_BATCH_LIMIT)) {
    const batch = firestore.batch();
    for (const uid of batchUids) {
      batch.delete(firestore.collection("users").doc(uid));
    }
    await batch.commit();
  }
}

exports.cleanupAnonymousUsers = onSchedule(
    {
      // Runs once a month, at 00:00 UTC on the 1st.
      schedule: "0 0 1 * *",
      timeZone: "Etc/UTC",
    },
    async () => {
      const auth = getAuth();
      const firestore = getFirestore();
      const cutoff = Date.now() - STALE_AFTER_DAYS * 24 * 60 * 60 * 1000;

      let deletedCount = 0;
      let pageToken;

      do {
        const result = await auth.listUsers(LIST_USERS_PAGE_SIZE, pageToken);

        const staleUids = result.users
            .filter((user) => {
              const isAnonymous = user.providerData.length === 0;
              const lastActiveMs = new Date(
                  user.metadata.lastSignInTime || user.metadata.creationTime,
              ).getTime();
              return isAnonymous && lastActiveMs < cutoff;
            })
            .map((user) => user.uid);

        if (staleUids.length > 0) {
          for (const uidBatch of chunk(staleUids, LIST_USERS_PAGE_SIZE)) {
            await auth.deleteUsers(uidBatch);
          }
          await deleteFirestoreUserDocs(firestore, staleUids);
          deletedCount += staleUids.length;
        }

        pageToken = result.pageToken;
      } while (pageToken);

      console.log(`cleanupAnonymousUsers: deleted ${deletedCount} stale anonymous user(s).`);
    },
);

exports.notifyAdminOnNewDeposition = onValueCreated(
    "/depositions/{depositionId}",
    async (event) => {
      const deposition = event.data.val();
      if (!deposition) return;

      const firestore = getFirestore();
      const adminsSnapshot = await firestore
          .collection("users")
          .where("roleValue", "==", ADMIN_ROLE_VALUE)
          .get();

      const tokens = adminsSnapshot.docs
          .map((doc) => doc.data().fcmToken)
          .filter((token) => typeof token === "string" && token.length > 0);

      if (tokens.length === 0) {
        console.log("notifyAdminOnNewDeposition: no admin fcmToken(s) to notify.");
        return;
      }

      const author = deposition.isAnonymous ? "Someone" : (deposition.name || "Someone");
      const body = `${author}: ${deposition.deposition || ""}`.slice(0, NOTIFICATION_BODY_MAX_LENGTH);

      const response = await getMessaging().sendEachForMulticast({
        tokens,
        notification: {
          title: "New deposition received",
          body,
        },
      });
      console.log(`notifyAdminOnNewDeposition: sent to ${response.successCount}/${tokens.length} admin token(s).`);
    },
);
