import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/back_ground_container.dart';
import 'package:sivo_venues/common/divida.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/common/shimmers/itemlist_shimmer.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/notifications_controller.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/views/supplier/suppliers_page.dart';

class InvoicePage extends StatelessWidget {
  final String? orderId;
  const InvoicePage({super.key, required this.orderId});

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
            text: 'Invoice Details',
            style: appStyle(12, kGray, FontWeight.w600)),
      ),
      body: controller.loading == true
          ? const ItemsListShimmer()
          : BackGroundContainer(
          child: Column(
          children: [
            Container(
              width: width,
              height: height / 4.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r)),
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
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                            text:
                            controller.order!.supplierId.title,
                            style: appStyle(
                                20, kGray, FontWeight.bold)),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: kTertiary,
                          backgroundImage: NetworkImage(controller
                              .order!.supplierId.logoUrl),
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
                              style: appStyle(
                                  11, kGray, FontWeight.w600)),
                          ReusableText(
                              text: controller.order!.deliveryAddress
                                  .addressLine1,
                              style: appStyle(
                                  11, kGray, FontWeight.normal)),
                        ]),
                        TableRow(children: [
                          ReusableText(
                              text: "Supplier",
                              style: appStyle(
                                  11, kGray, FontWeight.w600)),
                          ReusableText(
                              text: controller.order!.supplierId
                                  .coords.address,
                              style: appStyle(
                                  11, kGray, FontWeight.normal)),
                        ]),
                        TableRow(children: [
                          ReusableText(
                              text: "Delivery Date",
                              style: appStyle(
                                  11, kGray, FontWeight.w600)),
                          ReusableText(
                              text: controller.order!.deliveryDate != null
                                  ? controller.order!.deliveryDate
                                  .toString()
                                  : "Not specified",
                              style: appStyle(
                                  11, kGray, FontWeight.normal)),
                        ]),
                        TableRow(children: [
                          ReusableText(
                              text: "Order Number",
                              style: appStyle(
                                  11, kGray, FontWeight.w600)),
                          ReusableText(
                              text: controller.order!.id
                                  .substring(0, 8),
                              style: appStyle(
                                  11, kGray, FontWeight.normal)),
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
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                  color: kLightWhite,
                  borderRadius: BorderRadius.circular(12.r)),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                },
                border: TableBorder.all(color: kGray),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                        color: kTertiary.withOpacity(0.1)),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: ReusableText(
                            text: "Title",
                            style: appStyle(
                                12, kGray, FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: ReusableText(
                            text: "Qty",
                            style: appStyle(
                                12, kGray, FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: ReusableText(
                            text: "Unit",
                            style: appStyle(
                                12, kGray, FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: ReusableText(
                            text: "Amount",
                            style: appStyle(
                                12, kGray, FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...controller.order!.orderItems.map((item) =>
                      TableRow(children: [
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: ReusableText(
                              text: item.itemId.title,
                              style: appStyle(
                                  11, kGray, FontWeight.normal)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: ReusableText(
                              text: item.quantity.toString(),
                              style: appStyle(
                                  11, kGray, FontWeight.normal)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: ReusableText(
                              text: item.itemId.unit!,
                              style: appStyle(
                                  11, kGray, FontWeight.normal)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: ReusableText(
                              text: item.price.toStringAsFixed(2),
                              style: appStyle(
                                  11, kGray, FontWeight.normal)),
                        ),
                      ])).toList(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.h),
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
