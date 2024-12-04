import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rivus_user/models/api_error.dart';
import 'package:rivus_user/models/cart_response.dart';
import 'package:rivus_user/models/environment.dart';
import 'package:rivus_user/models/user_cart.dart';
import 'package:rivus_user/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import 'counter_controller.dart';

class CartController extends GetxController {
  final box = GetStorage();

  // Reactive state for cart items
  RxInt cartItemCount = 0.obs;

  // Reactive state
  var _address = false.obs;

  // Getter
  bool get address => _address.value;

  // Setter
  set setAddress(bool newValue) {
    _address.value = newValue;
  }

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  Future<void> addToCart(String item) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/cart');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: item,
      );

      if (response.statusCode == 201) {
        setLoading = false;

        CartResponse data = cartResponseFromJson(response.body);

        box.write("cart", jsonEncode(data.count));

        // //Update the cart item count
        // cartItemCount.value = data.count ??0;

      } else {
        var data = apiErrorFromJson(response.body);
      }
    } catch (e) {
      setLoading = false;
    } finally {
      setLoading = false;
    }
  }

  Future<void> decrementFromCart(String productId) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/cart/decrement');

    // Prepare the body for the request
    var body = jsonEncode({
      "productId": productId,
    });

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        CartResponse data = cartResponseFromJson(response.body);

        box.write("cart", jsonEncode(data.count));

      } else {
        var data = apiErrorFromJson(response.body);
      }
    } catch (e) {
      setLoading = false;
    } finally {
      setLoading = false;
    }
  }

  void removeFormCart(String supplierId, String productId) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/cart/delete/$productId');

    try {
      var response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });

      if (response.statusCode == 200) {
        setLoading = false;
        CartResponse data = cartResponseFromJson(response.body);

        Get.find<CounterController>().resetItemCount(supplierId, productId);

        box.write("cart", jsonEncode(data.count));

        Get.snackbar("Product removed",
            "The product was removed from cart successfully",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Icons.add_alert));
        // Get.offAll(() =>  MainScreen());
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

  void clearCart({String? supplierId}) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse(
        '${Environment.appBaseUrl}/api/cart/clear${supplierId != null ? '?supplierId=$supplierId' : ''}'); // Adjust the URL as necessary

    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        setLoading = false;

        if (supplierId != null) {
          Map<String, dynamic> storedCounts = box.read('supplierItemCounts') ?? {};
          storedCounts.remove(supplierId);
          box.write('supplierItemCounts', storedCounts);

          // Update the counter_controller's supplierItemCounts observable
          final counterController = Get.find<CounterController>();
          counterController.supplierItemCounts.remove(supplierId);
        } else {
          box.remove("supplierItemCounts");
          final counterController = Get.find<CounterController>();
          counterController.supplierItemCounts.clear();
        }
      } else {
        var data = apiErrorFromJson(response.body);
        Get.snackbar(data.message, "Failed to clear cart, please try again",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;
      Get.snackbar(e.toString(), "Failed to clear cart, please try again",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void loadCartCount() {
    var cartData = box.read('cart');
    if (cartData != null) {
      //cartItemCount.value = jsonDecode(cartData);
    }
  }
}
