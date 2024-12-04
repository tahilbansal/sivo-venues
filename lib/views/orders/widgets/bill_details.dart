// lib/widgets/bill_details_widget.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rivus_user/common/app_style.dart';
import 'package:rivus_user/common/divida.dart';
import 'package:rivus_user/common/reusable_text.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/controllers/address_controller.dart';
import 'package:rivus_user/models/distance_time.dart';
import 'package:rivus_user/views/auth/phone_verification.dart';
import 'package:rivus_user/views/supplier/suppliers_page.dart';


// Add any other necessary imports for DistanceTime, AddressController, etc.

TextEditingController _phone = TextEditingController();

Widget buildBillDetails(
    BuildContext context,
    double width,
    double grandTotal,
    double grandPriceDelivery,
    DistanceTime distanceTime,
    AddressController controller,
    ) {
  return Container(
    width: width,
    padding: EdgeInsets.symmetric(horizontal: 18.w),
    decoration: BoxDecoration(
      color: kLightWhite,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Text("Bill Details", style: appStyle(12, kDark, FontWeight.w500)),
        SizedBox(height: 4.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "(Rivus does not guarantee the accuracy of prices)",
              style: TextStyle(fontSize: 11, color: kGray),
              softWrap: true,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        RowText(first: "Item Total", second: "\₹ ${grandTotal.toStringAsFixed(2)}"),
        SizedBox(height: 5.h),
        RowText(
          first: controller.defaultAddress == null ? "Delivery Fee To Current Location" : "Delivery Fee",
          second: "\₹ ${distanceTime.price.toStringAsFixed(2)}",
        ),
        SizedBox(height: 5.h),
        RowText(first: "Estimated Order Total", second: "\₹ ${grandPriceDelivery.toStringAsFixed(2)}"),
        SizedBox(height: 5.h),
        const Divida(),
        SizedBox(height: 5.h),
        GestureDetector(
          onTap: () {
            Get.to(() => const PhoneVerificationPage());
          },
          child: RowText(
            first: "Phone",
            second: _phone.text.isEmpty ? "Tap to add a phone number before ordering" : _phone.text,
          ),
        ),
      ],
    ),
  );
}
