// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:rivus_user/common/entities/user.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/controllers/notifications_controller.dart';
import 'package:rivus_user/models/api_error.dart';
import 'package:rivus_user/models/environment.dart';
import 'package:rivus_user/models/login_request.dart';
import 'package:rivus_user/models/login_response.dart';
import 'package:rivus_user/views/auth/verification_page.dart';
import 'package:rivus_user/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rivus_user/views/message/controller.dart';

import '../views/auth/login_page.dart';

class LoginController extends GetxController {
  final controller = Get.put(NotificationsController());
  final messageController = Get.put(MessageController());
  final box = GetStorage();
  RxBool _isLoading = false.obs;
  final db = FirebaseFirestore.instance;
  bool get isLoading => _isLoading.value;
  LoginResponse? _loginResponse;
  LoginResponse? get loginResponse => _loginResponse;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void loginFunc(String model, LoginRequest login) async {
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/login');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: model,
      );
      if (response.statusCode == 200) {
        LoginResponse data = loginResponseFromJson(response.body);
        String userId = data.id;
        String userData = json.encode(data);

        box.write(userId, userData);
        box.write("user", userData);
        box.write("token", json.encode(data.userToken));
        box.write("userId", json.encode(data.id));
        box.write("verification", data.verification);

        // Force reload messages after login
        //await messageController.asyncLoadMsgData();
        messageController.reset();

        print("my token is ${json.encode(data.userToken)}");
        if (data.phoneVerification == true) {
          box.write("phone_verification", true);
        } else {
          box.write("phone_verification", false);
        }

        setLoading = false;
        controller.updateUserToken(controller.fcmToken);
        Get.snackbar("Successfully logged in ", "Enjoy your awesome experience",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));

        var userbase = await db
            .collection("users")
            .withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userdata, options) =>
                  userdata.toFirestore(),
            )
            .where("id", isEqualTo: userId)
            .get();

        if (userbase.docs.isEmpty) {
          print("docs---empty");
          final data = UserData(
              id: userId,
              name: "",
              email: login.email,
              photourl: "",
              location: "",
              fcmtoken: "",
              addtime: Timestamp.now());
          try {
            await db
                .collection("users")
                .withConverter(
                  fromFirestore: UserData.fromFirestore,
                  toFirestore: (UserData userdata, options) => userdata.toFirestore(),
                ).add(data);

            print("docs---updated");
          } catch (e) {
            print("Error adding document: $e");
          }
          print("docs---updated");
        } else {
          print("docs---exist");
        }

        if (data.verification == false) {
          Get.offAll(() => const VerificationPage(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        } else {
          Get.offAll(() => MainScreen(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        }
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to login, please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to login, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void loginFuncPhone(String model, LoginRequest login) async {
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/login');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: model,
      );
      if (response.statusCode == 200) {
        LoginResponse data = loginResponseFromJson(response.body);
        String userId = data.id;
        String userData = json.encode(data);

        box.write(userId, userData);
        box.write("user", userData);
        box.write("token", json.encode(data.userToken));
        box.write("userId", json.encode(data.id));
        box.write("verification", data.verification);

        print("my token is ${json.encode(data.userToken)}");
        if (data.phoneVerification == true) {
          box.write("phone_verification", true);
        } else {
          box.write("phone_verification", false);
        }

        setLoading = false;
        controller.updateUserToken(controller.fcmToken);
        Get.snackbar("Successfully logged in ", "Enjoy your awesome experience",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));

        var userbase = await db
            .collection("users")
            .withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userdata, options) =>
                  userdata.toFirestore(),
            )
            .where("id", isEqualTo: userId)
            .get();

        if (userbase.docs.isEmpty) {
          print("docs---empty");
          final data = UserData(
              id: userId,
              name: "",
              email: login.email,
              photourl: "",
              location: "",
              fcmtoken: "",
              addtime: Timestamp.now());
          try {
            await db
                .collection("users")
                .withConverter(
                  fromFirestore: UserData.fromFirestore,
                  toFirestore: (UserData userdata, options) =>
                      userdata.toFirestore(),
                )
                .add(data);

            print("docs---updated");
          } catch (e) {
            print("Error adding document: $e");
          }
          print("docs---updated");
        } else {
          print("docs---exist");
        }

        if (data.verification == false) {
          Get.offAll(() => const VerificationPage(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        } else {
          Get.offAll(() => MainScreen(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        }
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to login, please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to login, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void logout() {
    box.erase();
    // final messageController = Get.find<MessageController>();
    // messageController.reset();
    Get.delete<MessageController>();

    Get.offAll(() => Login(),
        transition: Transition.fade, duration: const Duration(seconds: 1));
  }

  LoginResponse? getUserData() {
    String? userId = box.read("userId");
    String? data = box.read(jsonDecode(userId!));
    if (data != null) {
      return loginResponseFromJson(data);
    }
    return null;
  }

  void deleteAccount() async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/api/users');

    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        setLoading = false;
        box.erase();
        Get.offAll(() => MainScreen(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to delete, please try again",
            backgroundColor: kRed,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to delete, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }
}
