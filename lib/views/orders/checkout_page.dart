import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/back_ground_container.dart';
import 'package:sivo_venues/common/divida.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/address_controller.dart';
import 'package:sivo_venues/controllers/order_controller.dart';
import 'package:sivo_venues/hooks/fetchCart.dart';
import 'package:sivo_venues/hooks/fetchDefaultAddress.dart';
import 'package:sivo_venues/models/distance_time.dart';
import 'package:sivo_venues/models/items.dart';
import 'package:sivo_venues/models/order_item.dart';
import 'package:sivo_venues/models/suppliers.dart';
import 'package:sivo_venues/services/distance.dart';
import 'package:sivo_venues/views/home/widgets/custom_btn.dart';
import 'package:sivo_venues/views/orders/payment.dart';
import 'package:sivo_venues/views/orders/widgets/bill_details.dart';
import 'package:sivo_venues/views/orders/widgets/order_tile.dart';
import 'package:sivo_venues/views/profile/shipping_address.dart';
import 'package:sivo_venues/views/supplier/suppliers_page.dart';
import 'package:get/get.dart';

import '../../common/show_snack_bar.dart';
import '../../controllers/contact_controller.dart';
import '../../hooks/fetchSupplier.dart';
import '../../models/response_model.dart';
import '../../models/user_cart.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CheckoutPage extends HookWidget {
  CheckoutPage(
      {super.key, required this.supplierId, required this.deliveryDate});

  final String? supplierId;
  final DateTime deliveryDate;

  TextEditingController _phone = TextEditingController();

  Future<ResponseModel> loadData() async {
    return Get.find<ContactController>().asyncLoadSingleSupplier();
  }

  void loadChatData() async {
    ResponseModel response = await loadData();
    if (response.isSuccess == false) {
      showCustomSnackBar(response.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    final orderController = Get.put(OrderController());
    final hookResult = useFetchDefault(context, false);

    final supplierHookResult = useFetchSupplier(supplierId);
    var supplier = supplierHookResult.data;

    // Fetching cart items using API hook
    final cartHookResult = useFetchCart(supplierId: supplierId);
    var userCarts = cartHookResult.data ?? [];
    List<CartItem> cartItems = [];
    double grandTotal = 0.0;

    DistanceTime distanceTime;

    if (supplier != null) {
      Get.find<ContactController>().state.ownerId.value = supplier.owner;
      loadChatData();

      distanceTime = Distance().calculateDistanceTimePrice(
        controller.defaultAddress!.latitude,
        controller.defaultAddress!.longitude,
        supplier.coords.latitude,
        supplier.coords.longitude,
        10,
        2.00,
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }

    if (userCarts != null) {
      for (var userCart in userCarts) {
        cartItems.addAll(userCart.items);
        grandTotal = userCart.grandTotal;
      }
    } else {
      return Center(child: CircularProgressIndicator());
    }

    //double totalTime = 25 + distanceTime.time;
    double grandPriceDelivery = grandTotal + distanceTime.price;

    return Obx(
      () => orderController.paymentUrl.contains("https")
          ? const PaymentWebView()
          : Scaffold(
              backgroundColor: kOffWhite,
              appBar: AppBar(
                backgroundColor: kLightWhite,
                elevation: 0,
                centerTitle: true,
                leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(CupertinoIcons.back)),
                title: Text(
                  "Order Details",
                  style: appStyle(14, kDark, FontWeight.w500),
                ),
              ),
              body: SafeArea(
                child: Container(
                  color: kOffWhite,
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        decoration: BoxDecoration(
                            color: kLightWhite,
                            borderRadius: BorderRadius.circular(18.r)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                    text: supplier.title!,
                                    style:
                                        appStyle(20, kGray, FontWeight.bold)),
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: kTertiary,
                                  backgroundImage:
                                      NetworkImage(supplier.imageUrl!),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * 0.3,
                                  child: ReusableText(
                                      text: "Delivering to",
                                      style:
                                          appStyle(10, kGray, FontWeight.w500)),
                                ),
                                SizedBox(
                                  width: width * 0.585,
                                  child: Text(
                                    (controller.userAddress != null &&
                                            controller.userAddress!.length > 50)
                                        ? controller.userAddress!
                                                .substring(0, 50) +
                                            '...'
                                        : (controller.userAddress ??
                                            "Provide an address to proceed ordering"),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: appStyle(10, kGray, FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            RowText(
                                first: "Business Hours", second: supplier.time),
                            SizedBox(
                              height: 5.h,
                            ),
                            RowText(
                                first: "Order Delivery Date",
                                second:
                                    "${DateFormat('yyyy-MM-dd').format(deliveryDate)}"),
                            SizedBox(
                              height: 5.h,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        height: 0.58 * height,
                        decoration: BoxDecoration(
                            color: kLightWhite,
                            borderRadius: BorderRadius.circular(18.r)),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            return OrderTile(cartItem: cartItems[index]);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 16.0),
                        color: kLightWhite,
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12.r)),
                                  ),
                                  backgroundColor: kLightWhite,
                                  builder: (context) => SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: buildBillDetails(
                                        context,
                                        width,
                                        grandTotal,
                                        grandPriceDelivery,
                                        distanceTime,
                                        controller),
                                  ),
                                );
                              },
                              child: Text("View Bill Details",
                                  style:
                                      appStyle(14, kPrimary, FontWeight.w500)),
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                  text:
                                      "₹${grandPriceDelivery.toStringAsFixed(2)}",
                                  style: appStyle(18, kDark, FontWeight.bold),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: controller.defaultAddress == null
                                      ? CustomButton(
                                          onTap: () {
                                            Get.to(() => const AddAddress());
                                          },
                                          radius: 9,
                                          color: kPrimary,
                                          btnWidth: width * 0.95,
                                          btnHieght: 34.h,
                                          text: "Add  Default Address",
                                        )
                                      : orderController.isLoading
                                          ? const CircularProgressIndicator
                                              .adaptive(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      kPrimary),
                                            )
                                          : CustomButton(
                                              onTap: () {
                                                // Convert cartItems to orderItems
                                                List<OrderItem> orderItems =
                                                    cartItems.map((cartItem) {
                                                  return OrderItem(
                                                    itemId:
                                                        cartItem.productId.id,
                                                    quantity: cartItem.quantity
                                                        .toString(),
                                                    price: cartItem.totalPrice
                                                        .toString(),
                                                    additives: [],
                                                    instructions: '',
                                                  );
                                                }).toList();
                                                Order order = Order(
                                                    userId: controller
                                                        .defaultAddress!.userId,
                                                    orderItems: orderItems,
                                                    orderTotal: grandTotal
                                                        .toStringAsFixed(2),
                                                    supplierAddress:
                                                        supplier.coords.address,
                                                    supplierCoords: [
                                                      supplier.coords.latitude,
                                                      supplier.coords.longitude
                                                    ],
                                                    recipientCoords: [
                                                      controller.defaultAddress!
                                                          .latitude,
                                                      controller.defaultAddress!
                                                          .longitude
                                                    ],
                                                    deliveryFee: distanceTime
                                                        .price
                                                        .toStringAsFixed(2),
                                                    grandTotal:
                                                        grandPriceDelivery
                                                            .toStringAsFixed(2),
                                                    deliveryAddress: controller
                                                        .defaultAddress!.id,
                                                    deliveryDate: deliveryDate,
                                                    paymentMethod: "STRIPE",
                                                    supplierId: supplier.id!);

                                                String orderData =
                                                    orderToJson(order);

                                                orderController.order = order;

                                                orderController.createOrder(
                                                    cartItems,
                                                    orderData,
                                                    order,
                                                    supplier);
                                              },
                                              radius: 9,
                                              color: kPrimary,
                                              btnWidth: width * 0.95,
                                              btnHieght: 45.h,
                                              text: "PLACE ORDER",
                                            ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
