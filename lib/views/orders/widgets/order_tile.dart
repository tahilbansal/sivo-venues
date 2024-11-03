import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivus_user/common/app_style.dart';
import 'package:rivus_user/common/reusable_text.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/models/items.dart';
import 'package:rivus_user/views/item/item_page.dart';
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
        // Navigate to item details page if needed
        // Get.to(
        //         () => ItemPage(
        //       item: cartItem.productId, // Navigate with the item details
        //     ),
        //     transition: Transition.native,
        //     duration: const Duration(seconds: 1));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 0.h, right: 8.w, left: 8.w),
        height: 70,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          //borderRadius: BorderRadius.all(Radius.circular(9)),
        ),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ClipRRect(
              //   borderRadius: const BorderRadius.all(Radius.circular(12)),
              //   child: Stack(
              //     children: [
              //       SizedBox(
              //         height: 75.h,
              //         width: 80.h,
              //         child: Image.network(
              //           cartItem.productId
              //               .imageUrl[0], // Use the image URL from cart item
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  ReusableText(
                    text: cartItem.productId.title,
                    style: appStyle(11, kDark, FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  ReusableText(
                    text: 'Quantity: ${cartItem.quantity}', // Show item quantity
                    style: appStyle(9, kGray, FontWeight.w400),
                  ),
                  ReusableText(
                    text:
                        'Total Price: \$${cartItem.totalPrice.toStringAsFixed(2)}', // Show total price
                    style: appStyle(9, kGray, FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
