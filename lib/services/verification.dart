import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sivo_venues/controllers/phone_verification_controller.dart';
import 'package:get/get.dart';

class AuthService {
  final controller = Get.put(PhoneVerificationController());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int? _resendToken;
  String? _fcmToken;

  // Constructor to initialize FCM token
  AuthService() {
    _initFCMToken();
  }

  // Initialize FCM token
  Future<void> _initFCMToken() async {
    _fcmToken = await FirebaseMessaging.instance.getToken();
  }

  // Trigger the phone verification process
  Future<void> verifyPhoneNumber(String phoneNumber,
      {required Null Function(String verificationId, int? resendToken)
          codeSent}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential).then((value) {
          final String otp = credential.smsCode ?? '';
          controller.verifyOTP(phoneNumber, otp, _fcmToken!);
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint(e.message);
      },
      codeSent: (String verificationId, int? resendToken) async {
        codeSent(verificationId, resendToken);
        _resendToken = resendToken;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
      forceResendingToken: _resendToken,
    );
  }

  // Function to verify the SMS code entered by the user
  Future<void> verifySmsCode(
      String verificationId, String smsCode, String phoneNumber) async {
    // Create a PhoneAuthCredential using the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await _auth.signInWithCredential(credential).then((value) {
      controller.verifyOTP(phoneNumber, smsCode, _fcmToken!);
    });
  }
}
