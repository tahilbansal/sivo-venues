import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivus_user/common/app_style.dart';
import 'package:rivus_user/common/reusable_text.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/models/order_details.dart';

class OrderPageTile extends StatelessWidget {
  const OrderPageTile({
    super.key,
    required this.item,
    required this.status,
  });

  final OrderItem item;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: kLightWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.itemId.imageUrl.isNotEmpty && item.itemId.imageUrl[0].isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                item.itemId.imageUrl[0],
                height: 70.h,
                width: 70.h,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        item.itemId.title,
                        style: appStyle(13, kDark, FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ReusableText(
                      text: item.price != null ? "\u20B9${item.price}" : "",
                      style: appStyle(14, kPrimary, FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                ReusableText(
                  text: "Quantity: ${item.quantity}",
                  style: appStyle(11, kGray, FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
