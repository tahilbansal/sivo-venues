import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivus_user/common/app_style.dart';
import 'package:rivus_user/common/back_ground_container.dart';
import 'package:rivus_user/common/divida.dart';
import 'package:rivus_user/common/reusable_text.dart';
import 'package:rivus_user/common/shimmers/itemlist_shimmer.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/controllers/notifications_controller.dart';
import 'package:rivus_user/views/orders/widgets/order_page_tile.dart';
import 'package:get/get.dart';

import '../supplier/suppliers_page.dart';

class OrderDetailsPage extends StatelessWidget {
  final String? orderId;
  const OrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    // Fetch the order details using the orderId passed in
    controller.getOrder(orderId!);

    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: ReusableText(
                text: 'Order Details Page',
                style: appStyle(12, kGray, FontWeight.w600)),
          ),
          body: controller.loading == true
              ? const ItemsListShimmer()
              : BackGroundContainer(
                  child: controller.order == null
                      ? Center(
                    child: ReusableText(
                      text: "The order has been deleted",
                      style: appStyle(16, kGray, FontWeight.bold),
                    ),
                  )
                  :Column(
                    children: [
                      Container(
                        width: width,
                        height: hieght / 4.2,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0),
                          decoration: BoxDecoration(
                              color: kLightWhite,
                              borderRadius: BorderRadius.circular(12.r)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ReusableText(
                                      text: controller.order!.supplierId.title,
                                      style: appStyle(20, kGray, FontWeight.bold)),
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: kTertiary,
                                    backgroundImage: NetworkImage(controller.order!.supplierId.logoUrl),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              RowText(
                                  first: "Business Hours",
                                  second: controller.order!.supplierId.time),
                              SizedBox(
                                height: 5.h,
                              ),
                              const Divida(),
                              SizedBox(
                                height: 5.h,
                              ),
                              Table(
                                children: [
                                  TableRow(children: [
                                    ReusableText(
                                        text: "Recipient",
                                        style: appStyle(11, kGray, FontWeight.w600)),
                                    ReusableText(
                                        text: controller.order!.deliveryAddress.addressLine1,
                                        style: appStyle(11, kGray, FontWeight.normal)),
                                  ]),
                                  TableRow(children: [
                                    ReusableText(
                                        text: "Supplier",
                                        style: appStyle(11, kGray, FontWeight.w600)),
                                    ReusableText(
                                        text: controller.order!.supplierId.coords.address,
                                        style: appStyle(11, kGray, FontWeight.normal)),
                                  ]),
                                  TableRow(children: [
                                    ReusableText(
                                        text: "Delivery Date",
                                        style: appStyle(11, kGray, FontWeight.w600)),
                                    ReusableText(
                                        text: controller.order!.deliveryDate != null
                                            ? controller.order!.deliveryDate.toString()
                                            : "Not specified",
                                        style: appStyle(11, kGray, FontWeight.normal)),
                                  ]),
                                  TableRow(children: [
                                    ReusableText(
                                        text: "Order Number",
                                        style: appStyle(
                                            11, kGray, FontWeight.w600)),
                                    ReusableText(
                                        text: controller.order!.id.substring(0,8),
                                        style: appStyle(
                                            11, kGray, FontWeight.normal)),
                                  ]),
                                  TableRow(children: [
                                    ReusableText(
                                        text: "Order Status",
                                        style: appStyle(
                                            11, kGray, FontWeight.w600)),
                                    ReusableText(
                                        text: controller.order!.orderStatus,
                                        style: appStyle(10, kPrimary, FontWeight.w600)),
                                  ]),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        color: kLightWhite,
                        height: 0.53 * hieght,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.order!.orderItems.length,
                          itemBuilder: (context, index) {
                            return OrderPageTile(
                              item: controller.order!.orderItems[index],
                              status: controller.order!.orderStatus,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Price", style: appStyle(16, Colors.black, FontWeight.bold)),
                            Text("₹${controller.order?.orderTotal.toStringAsFixed(2)}", style: appStyle(17, Colors.black, FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
