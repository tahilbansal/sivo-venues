// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:rivus_user/common/app_style.dart';
import 'package:rivus_user/common/reusable_text.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/models/suppliers.dart';
import 'package:rivus_user/views/supplier/suppliers_page.dart';
import 'package:get/get.dart';

class SupplierTile extends StatelessWidget {
  const SupplierTile({
    super.key,
    required this.supplier,
  });

  final Suppliers supplier;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => SupplierPage(
                  supplier: supplier,
                ),
            transition: Transition.native,
            duration: const Duration(seconds: 1));
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 70,
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
                            height: 70.h,
                            width: 70.w,
                            child: Image.network(
                              supplier.imageUrl!,
                              fit: BoxFit.cover,
                            )),
                        // Positioned(
                        //     bottom: 0,
                        //     child: Container(
                        //       padding:
                        //           const EdgeInsets.only(left: 6, bottom: 2),
                        //       color: kGray.withOpacity(0.6),
                        //       height: 16,
                        //       width: width,
                        //       child: RatingBarIndicator(
                        //         rating: 5,
                        //         itemBuilder: (context, index) => const Icon(
                        //           Icons.star,
                        //           color: Colors.amber,
                        //         ),
                        //         itemCount: 5,
                        //         itemSize: 15.0,
                        //         direction: Axis.horizontal,
                        //       ),
                        //     )
                        // )
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
                          text: supplier.title!,
                          style: appStyle(11, kDark, FontWeight.w400)),
                      ReusableText(
                          text: "Delivery time: ${supplier.time}",
                          style: appStyle(9, kGray, FontWeight.w400)),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      SizedBox(
                        width: width * 0.7,
                        child: Text(supplier.coords.address,
                            overflow: TextOverflow.ellipsis,
                            style: appStyle(9, kGray, FontWeight.w400)),
                      ),
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
              decoration: BoxDecoration(
                  color: supplier.isAvailable == true ||
                          supplier.isAvailable == null
                      ? kPrimary
                      : kSecondaryLight,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Center(
                child: ReusableText(
                  text: supplier.isAvailable == null ||
                          supplier.isAvailable == true
                      ? "OPEN"
                      : "CLOSED",
                  style: appStyle(12, kLightWhite, FontWeight.bold),
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
                      MaterialCommunityIcons.shopping_outline,
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
