import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:rivus_user/common/app_style.dart';
import 'package:rivus_user/common/reusable_text.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/models/suppliers.dart';
import 'package:rivus_user/views/supplier/directions_page.dart';

class SupplierTopBar extends StatelessWidget {
  const SupplierTopBar({
    super.key,
    required this.title,
    required this.supplier,
  });

  final String title;
  final Suppliers supplier;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 90.h,
          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Ionicons.chevron_back_circle,
                  color: kPrimary,
                  size: 30,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 40),
              //   child: Container(
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              //     child: ReusableText(
              //         text: title,
              //         style: appStyle(16, kLightWhite, FontWeight.w700)),
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  Get.to(() => DirectionsPage(
                        supplier: supplier,
                      ));
                },
                child: const Icon(
                  Entypo.direction,
                  color: kPrimary,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
