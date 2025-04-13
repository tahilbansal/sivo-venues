import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/models/items.dart';
import 'package:sivo_venues/views/item/item_page.dart';
import 'package:get/get.dart';

import '../../../models/user_cart.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.cartItem,
  });

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigate to item details page if needed
        // Get.to(
        //         () => ItemPage(
        //       item: cartItem.productId, // Navigate with the item details
        //     ),
        //     transition: Transition.native,
        //     duration: const Duration(seconds: 1));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 0.h, right: 8.w, left: 8.w),
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: kLightWhite,
          //borderRadius: BorderRadius.all(Radius.circular(9)),
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 2),
              Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product title
                      Expanded(
                        child: ReusableText(
                          text: cartItem.productId.title,
                          style: appStyle(12, kDark, FontWeight.w400),
                        ),
                      ),
                      // Product total price
                      ReusableText(
                        text: cartItem.totalPrice == 0.0
                         ? '--'
                         : '₹${cartItem.totalPrice.toStringAsFixed(2)}',
                        style: appStyle(12, kDark, FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  ReusableText(
                    text: 'Quantity: ${cartItem.quantity}',
                    style: appStyle(11, kGray, FontWeight.w400),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
