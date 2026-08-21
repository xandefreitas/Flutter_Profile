import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/bloc/languageBloc/language_bloc.dart';
import 'common/bloc/skillsBloc/skills_bloc.dart';
import 'common/util/default_firebase_options.dart';
import 'core/consts.dart';
import 'flutter_profile.dart';

Future<void> _firebaseMessagingBackgroundHandler(_) async =>
    Firebase.initializeApp();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Must run before any DatabaseReference/Firestore call is made (both
  // throw if their persistence setting is changed after first use) — this
  // is what lets cached data survive a cold start with no connection.
  FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: Consts.databaseUrl,
  ).setPersistenceEnabled(true);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LanguageBloc()),
          BlocProvider(create: (context) => SkillsBloc()),
        ],
        child: FlutterProfile(),
      ),
    ),
  );
}
