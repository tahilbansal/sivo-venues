import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/back_ground_container.dart';
import 'package:sivo_venues/common/divida.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/common/shimmers/itemlist_shimmer.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/notifications_controller.dart';
import 'package:sivo_venues/views/orders/widgets/order_page_tile.dart';
import 'package:sivo_venues/views/supplier/suppliers_page.dart';
import 'package:get/get.dart';

class OrderNotificationDetailsPage extends StatelessWidget {
  const OrderNotificationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());
    final message =
        ModalRoute.of(context)!.settings.arguments as NotificationResponse;

    print(" notifications page payload ${message.payload}");
    var orderData = jsonDecode(message.payload.toString());

    controller.getOrder(orderData['orderId']);

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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        width: width,
                        height: hieght / 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r)),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0),
                          decoration: BoxDecoration(
                              color: kOffWhite,
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
                                      text: controller.order!.supplierId.title,
                                      style:
                                          appStyle(20, kGray, FontWeight.bold)),
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: kTertiary,
                                    backgroundImage: NetworkImage(
                                        controller.order!.supplierId.logoUrl),
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
                                        text: controller
                                            .order!.supplierId.coords.address,
                                        style: appStyle(
                                            11, kGray, FontWeight.normal)),
                                  ]),
                                  TableRow(children: [
                                    ReusableText(
                                        text: "Order Number",
                                        style: appStyle(
                                            11, kGray, FontWeight.w600)),
                                    ReusableText(
                                        text: controller.order!.id,
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
                      OrderPageTile(
                        item: controller.order!.orderItems![0],
                        status: controller.order!.orderStatus,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      //  controller.order!.orderStatus == 'Out_for_Delivery' ?
                      // Container(
                      //  // padding: EdgeInsets.symmetric(horizontal: 9.w),
                      //      margin: EdgeInsets.fromLTRB(8.w, 0.w, 8.w, 0),
                      //      decoration: BoxDecoration(
                      //          color: kSecondaryLight,
                      //          borderRadius: BorderRadius.circular(30.r)),
                      //  child: Row(
                      //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //    children: [
                      //       CircleAvatar(
                      //                radius: 16,
                      //                backgroundColor: kTertiary,
                      //                backgroundImage:
                      //                    NetworkImage(controller.order!.driverId!.driver.profile),
                      //              ),
                      //      Padding(
                      //        padding: const EdgeInsets.all(8.0),
                      //        child: Row(
                      //          mainAxisAlignment: MainAxisAlignment.center,
                      //          crossAxisAlignment: CrossAxisAlignment.center,
                      //          children: [
                      //            const Icon(SimpleLineIcons.screen_smartphone, color: kGray, size: 14),
                      //
                      //            SizedBox(width: 5.w,),
                      //            ReusableText(text: items.driverId!.driver.phone, style: appStyle(13, kGray, FontWeight.w400)),
                      //          ],
                      //        ),
                      //      ),
                      //    ],
                      //  ),
                      // ): const SizedBox.shrink()
                    ],
                  ),
                ),
        ));
  }
}
