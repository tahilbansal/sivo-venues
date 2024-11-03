// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/controllers/contact_controller.dart';
import 'package:rivus_user/controllers/login_controller.dart';
import 'package:rivus_user/models/api_error.dart';
import 'package:rivus_user/models/environment.dart';
import 'package:rivus_user/models/order_item.dart';
import 'package:rivus_user/models/order_response.dart';
import 'package:rivus_user/models/payment_request.dart';
import 'package:rivus_user/models/user_cart.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/suppliers.dart';
import '../models/user_cart.dart';
import '../models/user_cart.dart';
import '../views/message/chat/controller.dart';
import 'cart_controller.dart';

class OrderController extends GetxController {
  final box = GetStorage();

  Order? order;

  void set setOrder(Order newValue) {
    order = newValue;
  }

  final RxString _paymentUrl = ''.obs;

  String get paymentUrl => _paymentUrl.value;

  set paymentUrl(String newValue) {
    _paymentUrl.value = newValue;
  }

  final RxString _orderId = ''.obs;

  String get orderId => _orderId.value;

  set orderId(String newValue) {
    _orderId.value = newValue;
  }

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  RxBool _iconChanger = false.obs;

  bool get iconChanger => _iconChanger.value;

  set setIcon(bool newValue) {
    _iconChanger.value = newValue;
  }

  void createOrder(List<CartItem> cartItems, String order, Order item,
      Suppliers supplier) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/orders');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: order,
      );

      if (response.statusCode == 201) {
        setLoading = false;
        OrderResponse data = orderResponseFromJson(response.body);

        orderId = data.orderId;

        Get.snackbar("Order successfully created", data.message,
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Icons.money));

        // Clear the cart for the specific supplier
        clearCartForSupplier(item.supplierId);

        // Create order summary message
        String orderSummary = _createOrderSummary(cartItems);

        final _controller = Get.find<ContactController>();
        _controller.state.supplierId.value = supplier.id!;

        // Assigning the supplier ID to the controller state
        await _controller.goChat(supplier);

        final chatController = Get.put(ChatController());

        // Ensure controllers are initialized properly
        chatController.sendOrderMessage(orderSummary, orderId);

        Payment payment = Payment(userId: item.userId, cartItems: [
          CartItemPayment(
              name: item.orderItems[0].itemId,
              id: orderId,
              price: item.grandTotal,
              quantity: 1,
              supplierId: item.supplierId)
        ]);

        String paymentData = paymentToJson(payment);
        paymentFunction(paymentData);
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(
            data.message, "Failed to create an order, please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to create an order, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void clearCartForSupplier(String supplierId) {
    // Call the clearCart method from your CartController
    final cartController = Get.find<CartController>();
    cartController.clearCart(supplierId: supplierId);
  }

  void paymentFunction(String payment) async {
    setLoading = true;
    var url =
        Uri.parse('${Environment.paymentUrl}/stripe/create-checkout-session');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: payment,
      );

      if (response.statusCode == 200) {
        var urlData = jsonDecode(response.body);
        paymentUrl = urlData['url'] ?? ''; // Check for null
      }
    } catch (e) {
      setLoading = false;
    } finally {
      setLoading = false;
    }
  }
}

String _createOrderSummary(List<CartItem> items) {
  StringBuffer summary = StringBuffer();

  summary.writeln("Order placed successfully! 🛒\n");
  for (var item in items) {
    summary.writeln("${item.quantity} x ${item.productId.title}");
  }
  //summary.writeln("\nTotal: ₹${item.grandTotal}");
  //summary.writeln("\nClick the button below to view the order details.");

  return summary.toString();
}
