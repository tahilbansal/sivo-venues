// ignore_for_file: prefer_final_fields
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/models/api_error.dart';
import 'package:rivus_user/models/environment.dart';
import 'package:rivus_user/models/phone_verification.dart';
import 'package:rivus_user/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PhoneVerificationController extends GetxController {
  final box = GetStorage();

  var _code = '🇩🇪 91'.obs;

  String get code => _code.value;

  set code(String newValue) {
    _code.value = newValue;
  }

  var _phoneCode = '+91'.obs;

  String get phoneCode => _phoneCode.value;

  set phoneCode(String newValue) {
    _phoneCode.value = newValue;
  }

  var _phoneNumber = '+91'.obs;

  String get phoneNumber => _phoneNumber.value ?? '';

  set phoneNumber(String newValue) {
    _phoneNumber.value = newValue;
  }

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void verifyPhone() async {
    //String token = box.read('token');
    //String accessToken = jsonDecode(token);
    setLoading = true;

    var url = Uri.parse(
        '${Environment.appBaseUrl}/api/users/verify_phone/$phoneNumber');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          //'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        PhoneVerificationData data =
            phoneVerificationDataFromJson(response.body);

        box.write("phone_verification", data.phoneVerification);

        setLoading = false;
        phoneNumber = '';
        Get.snackbar("Successfully verified your phone number ",
            "Enjoy your awesome experience",
            colorText: kLightWhite,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));
        if (data.phoneVerification == true) {
          Get.offAll(() => MainScreen());
        }
      } else {
        var data = apiErrorFromJson(response.body);

        phoneNumber = '';
        Get.snackbar(data.message, "Failed to verify, please try again",
            backgroundColor: kRed,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;
      phoneNumber = '';
      Get.snackbar(e.toString(), "Failed to login, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  // Backend request to create or log in the user after successful phone verification
  Future<void> verifyWithBackend() async {
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/login_or_create');
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "phone_number": phoneNumber, // Pass the verified phone number
        }),
      );

      if (response.statusCode == 200) {
        // Assuming the backend sends user data or a token in the response
        var userData = jsonDecode(response.body);
        box.write("user_data", userData);

        // Navigate to the main screen or wherever needed after successful login/creation
        Get.offAll(() => MainScreen());
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to login or create user",
            backgroundColor: kRed,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      Get.snackbar(e.toString(), "Error logging in or creating user",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  Future<void> verifyOTP(
      String phoneNumber, String otp, String fcmToken) async {
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/verifyUserPhone');
    var body = jsonEncode({
      'phone_number': phoneNumber,
      'otp': otp,
      'fcmToken': fcmToken,
    });

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String userId = data.id;
        String userData = json.encode(data);

        box.write(userId, userData);
        box.write("user", userData);
        box.write("token", json.encode(data.userToken));
        box.write("userId", json.encode(data.id));
        box.write("verification", data.verification);
        box.write("phone_verification", data.phoneVerification);

        Get.snackbar("Login Successful", "Welcome back!",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));

        Get.offAll(() => MainScreen(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        Get.snackbar("Failed to verify", "Please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      Get.snackbar(e.toString(), "Failed to verify OTP",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }
}
