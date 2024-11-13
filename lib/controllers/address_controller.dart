// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/models/all_addresses.dart';
import 'package:rivus_user/models/api_error.dart';
import 'package:rivus_user/models/environment.dart';
import 'package:rivus_user/views/entrypoint.dart';
import 'package:rivus_user/views/home/home_page.dart';
import 'package:rivus_user/views/profile/address.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AddressController extends GetxController {
  final box = GetStorage();
  AddressesList? defaultAddress;
  Location? userLoc;
  String? userAddress;

  // Reactive state for each address switch
  var addressSwitches = <String, bool>{}.obs;

  // Function to initialize switch state for an address
  void initializeSwitchState(String addressId, bool initialValue) {
    if (!addressSwitches.containsKey(addressId)) {
      addressSwitches[addressId] = initialValue;
    }
  }

  // Getter and setter for switch state
  bool getSwitchState(String addressId) {
    return addressSwitches[addressId] ?? false;
  }
  void setSwitchState(String addressId, bool newValue) {
    addressSwitches[addressId] = newValue;
  }

  // Reactive state
  var _address = false.obs;
  var _dfSwitch = false.obs;
  RxBool _isLoading = false.obs;

  // Getter and setter for address
  bool get address => _address.value;
  set setAddress(bool newValue) {
    _address.value = newValue;
  }

  // Getter and setter for loading
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  // Getter and Setter for the switch
  bool get dfSwitch => _dfSwitch.value;
  set setDfSwitch(bool newValue) => _dfSwitch.value = newValue;

  void addAddress(String address) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/address');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: address,
      );

      if (response.statusCode == 201) {
        setLoading = false;

        Get.snackbar("Address successfully add",
            "Thank you for adding the address, you can now order food",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Icons.add_alert));

        Get.off(() => MainScreen(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to add address, please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to add address, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void setDefaultAddress(String id) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/address/default/$id');

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        setLoading = false;

        // Get.snackbar("Default Address successfully updated",
        //     "Thank you for updating the address, you can now order food",
        //     colorText: kLightWhite,
        //     backgroundColor: kPrimary,
        //     icon: const Icon(Icons.add_alert));

        // Update the switches, ensuring only one is active at a time
        addressSwitches.updateAll((key, value) => key == id);

        Get.off(() => MainScreen(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to update address, please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to update address, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  var _index = 0.obs;
  // Getter
  int get getIndex => _index.value;

  // Setter
  set setIndex(int newValue) {
    _index.value = newValue;
  }
}
