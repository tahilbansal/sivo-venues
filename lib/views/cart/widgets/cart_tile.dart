import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:rivus_user/common/app_style.dart';
import 'package:rivus_user/common/reusable_text.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/controllers/cart_controller.dart';
import 'package:rivus_user/controllers/counter_controller.dart';
import 'package:rivus_user/models/user_cart.dart';
import 'package:get/get.dart';

class CartTile extends HookWidget {
  const CartTile({
    super.key,
    required this.cartItem,
    //required this.onDelete,
  });

  final CartItem cartItem;
  //final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    final counterController = Get.find<CounterController>();
    var toItem = cartItem.toItem();

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 80,
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
                          height: 75.h,
                          width: 75.h,
                          child: Image.network(
                            cartItem.productId.imageUrl.isNotEmpty
                                ? cartItem.productId.imageUrl[0]
                                : 'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                          )),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.only(left: 6, bottom: 2),
                          color: kGray.withOpacity(0.6),
                          height: 16,
                          width: width,
                        )
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: width * 0.53,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                          text: cartItem.productId.title,
                          style: appStyle(11, kDark, FontWeight.w400)),
                      ReusableText(
                          text: "Delivery time: ${cartItem.productId.supplier.time}",
                          style: appStyle(9, kGray, FontWeight.w400)),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          right: 5.w,
          top: 12.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Increment/Decrement Buttons
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      counterController.increment(toItem);
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      child: const Icon(
                        AntDesign.plussquareo,
                        color: kPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Obx(
                        () => ReusableText(
                      text: "${counterController.getItemCount(toItem.supplier, toItem.id)}",
                      style: appStyle(16, kDark, FontWeight.w500),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  GestureDetector(
                    onTap: () {
                      counterController.decrement(toItem);
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      child: const Icon(
                        AntDesign.minussquareo,
                        color: kPrimary,
                      ),
                    ),
                  ),
                  // SizedBox(width: 6.w),
                  // // Delete Icon
                  // GestureDetector(
                  //   onTap: () {
                  //     onDelete();
                  //     controller.removeFormCart(
                  //         toItem.supplier, toItem.id);
                  //   },
                  //   child: Container(
                  //     width: 19.h,
                  //     height: 19.h,
                  //     decoration: const BoxDecoration(
                  //       color: kSecondary,
                  //       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //     ),
                  //     child: const Center(
                  //       child: Icon(
                  //         MaterialCommunityIcons.delete,
                  //         size: 15,
                  //         color: kLightWhite,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: 4.h),
              // Price Display
              Container(
                width: 60.h,
                height: 19.h,
                decoration: const BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Obx(
                    () => ReusableText(
                      text: "\₹ ${((cartItem.productId.price) * counterController.getItemCount(cartItem.productId.supplier.id, cartItem.productId.id).toDouble()).toStringAsFixed(2)}",
                    style: appStyle(12, kLightWhite, FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
