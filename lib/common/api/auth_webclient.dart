import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../enums/user_role.dart';
import '../models/personal_data.dart';

class AuthWebclient {
  final FirebaseAuth auth;
  AuthWebclient({required this.auth});
  String _verificationId = '';
  int? _resendToken;

  Future<void> verifyNumber({
    required String phoneNumber,
    required int timeoutDuration,
    required Function() whenVerified,
    required Function(String errorTitle, String message) onError,
  }) async {
    String result = '';
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: _resendToken,
      verificationCompleted: (PhoneAuthCredential phoneCredential) {},
      verificationFailed: (FirebaseException e) {
        result = switch (e.code) {
          'invalid-phone-number' => 'The provided phone number is not valid.',
          'too-many-requests' => 'You exceeded the limit of requests for now, please try again later.',
          'operation-not-allowed' => 'You are not allowed to do this operation',
          _ => e.message ?? 'Unknown error',
        };
        onError(e.code, result);
      },
      codeSent: (String verificationID, int? resendToken) async {
        whenVerified();
        _verificationId = verificationID;
        _resendToken = resendToken;
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        _verificationId = verificationID;
      },
      timeout: Duration(seconds: timeoutDuration),
    );
  }

  signIn({required String pin}) async {
    final UserCredential userCredential = await auth.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: pin,
      ),
    );
    if (userCredential.user?.displayName == null) createUser(auth.currentUser!);
    return userCredential;
  }

  Future<UserCredential> signInAnonymously() async {
    final userCredential = await auth.signInAnonymously();
    return userCredential;
  }

  Future<void> updateDisplayName(String name) async {
    final User user = auth.currentUser!;
    await user.updateDisplayName(name);
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "displayName": name,
    });
  }

  Future<void> createUser(User user) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "phoneNumber": user.phoneNumber,
        "displayName": user.displayName ?? '',
        "roleValue": 0,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> getUserRole() async {
    User user = FirebaseAuth.instance.currentUser!;
    if (!user.isAnonymous) {
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return snapshot['roleValue'] == UserRole.ADMIN.value;
    }
    return false;
  }

  static Future<PersonalData> getPersonalData() async {
    final response = await FirebaseFirestore.instance.collection('profileData').doc('data').get();
    if (response.data()?.isNotEmpty ?? false) {
      return PersonalData.fromMap(response.data()!);
    } else {
      return PersonalData();
    }
  }
}
