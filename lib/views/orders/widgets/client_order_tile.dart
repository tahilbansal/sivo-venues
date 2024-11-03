import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:rivus_user/common/app_style.dart';
import 'package:rivus_user/common/entities/message.dart';
import 'package:rivus_user/common/reusable_text.dart';
import 'package:rivus_user/common/show_snack_bar.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/controllers/contact_controller.dart';
import 'package:rivus_user/hooks/fetchSupplier.dart';
import 'package:rivus_user/models/client_orders.dart';
import 'package:rivus_user/models/response_model.dart';
import 'package:rivus_user/views/message/chat/view.dart';
//import 'package:rivus_user/views/reviews/review_page.dart';
import 'package:get/get.dart';
import 'package:rivus_user/views/orders/order_details_page.dart';

class ClientOrderTile extends HookWidget {
  const ClientOrderTile({
    super.key,
    required this.order,
  });

  final ClientOrders order;
  Future<ResponseModel> loadData() async {
    //prepare the contact list for this user.
    //get the supplier info from the firebase
    //get only one supplier info
    return Get.find<ContactController>().asyncLoadSingleSupplier();
  }

  void loadChatData() async {
    ResponseModel response = await loadData();
    if (response.isSuccess == false) {
      showCustomSnackBar(response.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchSupplier(order.supplierId);
    var supplierData = hookResult.data;
    final load = hookResult.isLoading;

    if (supplierData != null) {
      // Encoding to JSON string
      String jsonString = jsonEncode(supplierData);

      // Decoding the JSON string back to Map
      Map<String, dynamic> resData = jsonDecode(jsonString);

      // Assigning the supplier ID to the controller state
      Get.find<ContactController>().state.supplierId.value = resData["owner"];

      // Load chat data
      loadChatData();
    } else {
      return Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        Get.to(() => OrderDetailsPage(orderId: order.id));
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 80,
            width: width,
            decoration: const BoxDecoration(
                color: kOffWhite,
                borderRadius: BorderRadius.all(Radius.circular(9))),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Stack(
                      children: [
                        SizedBox(
                            height: 75.h,
                            width: 80.h,
                            child: Image.network(
                              supplierData.logoUrl,
                              fit: BoxFit.cover,
                            )),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 6, bottom: 2),
                              color: kGray.withOpacity(0.6),
                              height: 16,
                              width: width,
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                          text: supplierData.title,
                          style: appStyle(11, kDark, FontWeight.w400)),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 6.h,
            child: Container(
              width: 60.h,
              height: 19.h,
              decoration: const BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Center(
                child: ReusableText(
                  text: "\$ ${order.grandTotal}",
                  style: appStyle(12, kLightWhite, FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
            right: 5,
            bottom: 10.h,
            child: Container(
              width: 60.h,
              height: 19.h,
              decoration: const BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    ResponseModel status = await Get.find<ContactController>()
                        .goChat(supplierData);
                    if (status.isSuccess == false) {
                      showCustomSnackBar(status.message!, title: status.title!);
                    }
                  },
                  child: ReusableText(
                    text: "Chat",
                    style: appStyle(12, kLightWhite, FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              right: 70.h,
              top: 6.h,
              child: Container(
                width: 19.h,
                height: 19.h,
                decoration: const BoxDecoration(
                    color: kSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: GestureDetector(
                  onTap: () {},
                  child: const Center(
                    child: Icon(
                      MaterialCommunityIcons.cart_plus,
                      size: 15,
                      color: kLightWhite,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
