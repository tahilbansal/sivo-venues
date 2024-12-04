import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rivus_user/common/values/colors.dart';
import 'package:rivus_user/constants/constants.dart';

class ChatBar extends StatelessWidget {
  final VoidCallback onStartOrder;
  final VoidCallback onGoToCart;
  final bool hasItemsInCart;

  const ChatBar({Key? key,
    required this.onStartOrder,
    required this.onGoToCart,
    required this.hasItemsInCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: hasItemsInCart ? onGoToCart : onStartOrder,
        child: Container(
          height: 55.h,
          color: kPrimary,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hasItemsInCart ? "Go to Cart" : "Start Order",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Icon(
                Icons.arrow_forward, // Use the arrow-forward icon
                color: kLightWhite, // Icon color
                size: 20.sp, // Adjust size based on your design
              ),
            ],
          ),
        ),
      );
  }
}
