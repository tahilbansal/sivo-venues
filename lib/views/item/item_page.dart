import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/not_found.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/common/show_snack_bar.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/cart_controller.dart';
import 'package:sivo_venues/controllers/contact_controller.dart';
import 'package:sivo_venues/controllers/counter_controller.dart';
import 'package:sivo_venues/controllers/item_controller.dart';
import 'package:sivo_venues/hooks/fetchSupplier.dart';
import 'package:sivo_venues/models/items.dart';
import 'package:sivo_venues/models/response_model.dart';
import 'package:sivo_venues/views/auth/phone_verification.dart';
import 'package:sivo_venues/views/cart/widgets/cart_bar.dart';
import 'package:sivo_venues/views/home/widgets/custom_btn.dart';
import 'package:sivo_venues/views/supplier/suppliers_page.dart';

class ItemPage extends StatefulHookWidget {
  const ItemPage({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final TextEditingController _preferences = TextEditingController();

  final PageController _pageController = PageController();
  final ContactController _controller = Get.put(ContactController());
  final CounterController counterController = Get.find<CounterController>();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<ResponseModel> loadData() async {
    return _controller.asyncLoadSingleSupplier();
  }

  void loadChatData() async {
    ResponseModel response = await loadData();
    if (response.isSuccess == false) {
      showCustomSnackBar(response.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    var phone_verification = box.read('phone_verification');
    var address = box.read('default_address') ?? false;
    final itemController = Get.put(ItemController());
    final cartController = Get.put(CartController());
    //itemController.loadAdditives(widget.item.additives);
    final hookResult = useFetchSupplier(widget.item.supplier);
    var supplierData = hookResult.data;
    final load = hookResult.isLoading;

    if (load == false) {
      supplierData = hookResult.data;

      if (supplierData != null) {
        // Encoding to JSON string
        String jsonString = jsonEncode(supplierData);

        // Decoding the JSON string back to Map
        Map<String, dynamic> resData = jsonDecode(jsonString);

        // Assigning the supplier ID to the controller state
        _controller.state.supplierId.value = resData["_id"];

        _controller.state.ownerId.value = resData["owner"];

        // Load chat data
        loadChatData();
      } else {
        print("supplierData is null");
      }
    }

    String? token = box.read('token');
    return load == true
        ? const Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                color: kSecondary,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: kLightWhite,
            body: Stack(
              children: [
              ListView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Stack(
                  children: [
                    widget.item.imageUrl != null && widget.item.imageUrl!.isNotEmpty
                        ? ClipRRect(
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(25)),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 230.h,
                            child: PageView.builder(
                                itemCount: widget.item.imageUrl!.length,
                                controller: _pageController,
                                onPageChanged: (i) {
                                  itemController.currentPage(i);
                                },
                                itemBuilder: (context, i) {
                                  return Container(
                                    height: 230.h,
                                    width: width,
                                    color: kLightWhite,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: widget.item.imageUrl![i],
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  );
                                }
                              ),
                          ), // Placeholder for missing image,
                          Positioned(
                            bottom: 10,
                            child: Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  widget.item.imageUrl!.length,
                                  (index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        margin: EdgeInsets.all(4.h),
                                        width: itemController.currentPage == index
                                                ? 10 : 8,
                                        // ignore: unrelated_type_equality_checks
                                        height: itemController.currentPage == index
                                                ? 10 : 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: itemController.currentPage == index
                                              ? kSecondary
                                              : kGrayLight,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ): Image.asset('assets/images/No.png', height: 230.h),
                    Positioned(
                      top: 40.h,
                      left: 12,
                      right: 12,
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
                              size: 32,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Entypo.share,
                              color: kPrimary,
                              size: 32,
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 10,
                        right: 12,
                        child: CustomButton(
                            btnWidth: width / 5,
                            radius: 30,
                            color: kPrimary,
                            onTap: () async {
                              if (supplierData == null) {
                                Get.to(
                                    () => const NotFoundPage(
                                          text: "Can not open supplier page",
                                        ),
                                    transition: Transition.fade,
                                    duration: const Duration(seconds: 1),
                                    arguments: {});
                              } else {
                                ResponseModel status =
                                    await _controller.goChat(supplierData);
                                if (status.isSuccess == false) {
                                  showCustomSnackBar(status.message!,
                                      title: status.title!);
                                }
                              }
                            },
                            text: "Message")),
                    Positioned(
                      bottom: 10,
                      right: 95,
                      child: CustomButton(
                      btnWidth: width / 2.9,
                      radius: 30,
                      color: kPrimary,
                      onTap: () {
                        if (token == null) {
                          showCustomSnackBar(
                            "You are not logged in. Your distance measure is not correct",
                            title: "Distance alert",
                          );
                        }
                        Get.to(
                            () => supplierData == null
                                ? const NotFoundPage(
                                    text: "Can not open supplier page",
                                  )
                                : SupplierPage(supplier: supplierData),
                            transition: Transition.fade,
                            duration: const Duration(seconds: 1));
                      },
                      text: "View Supplier"))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableText(
                              text: widget.item.title,
                              style: appStyle(18, kDark, FontWeight.w600)),
                          widget.item.price != null
                              ? ReusableText(
                              text: widget.item.price!.toStringAsFixed(2),
                              style: appStyle(18, kPrimary, FontWeight.w600))
                              : const SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        widget.item.description,
                        maxLines: 8,
                        style: appStyle(10, kGray, FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      SizedBox(
                        height: 15.h,
                        child: ListView.builder(
                            itemCount: widget.item.itemTags.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              final tag = widget.item.itemTags[i];
                              return Container(
                                margin: EdgeInsets.only(right: 5.h),
                                decoration: BoxDecoration(
                                    color: kPrimary,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.r))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: ReusableText(
                                        text: tag,
                                        style: appStyle(
                                            8, kLightWhite, FontWeight.w400)),
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      // SizedBox(
                      //   height: 64.h,
                      //   child: CustomTextField(
                      //       controller: _preferences,
                      //       hintText: "Add a note",
                      //       maxLines: 3,
                      //       keyboardType: TextInputType.text,
                      //       validator: (value) {
                      //         if (value!.isEmpty) {
                      //           return "Please enter a note";
                      //         }
                      //         return null;
                      //       }),
                      // ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableText(
                              text: "Quantity",
                              style: appStyle(18, kDark, FontWeight.w600)),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () =>
                                      counterController.increment(widget.item),
                                  child: const Icon(
                                    AntDesign.plussquareo,
                                    color: kPrimary,
                                  )),
                              SizedBox(
                                width: 6.w,
                              ),
                              Obx(
                                () => Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: ReusableText(
                                      text:
                                          "${counterController.getItemCount(widget.item.supplier, widget.item.id)}",
                                      style:
                                          appStyle(16, kDark, FontWeight.w500)),
                                ),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              GestureDetector(
                                  onTap: () =>
                                      counterController.decrement(widget.item),
                                  child: const Icon(
                                    AntDesign.minussquareo,
                                    color: kPrimary,
                                  ))
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableText(
                              text: "Item Total",
                              style: appStyle(18, kDark, FontWeight.w600)),
                          Obx(
                                () => ReusableText(
                                text: "\₹ ${((widget.item.price ?? 0.0) * counterController.getItemCount(widget.item.supplier, widget.item.id).toDouble()).toStringAsFixed(2)}",
                                style: appStyle(18, kPrimary, FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     height: 40.h,
                //     width: width,
                //     decoration: BoxDecoration(
                //       color: kPrimary,
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(30.r),
                //       ),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             if (token == null) {
                //               Get.to(() => const Login(),
                //                   transition: Transition.fade,
                //                   duration: const Duration(seconds: 1));
                //             } else {
                //               //var user = controller.getUserData();
                //               if (phone_verification == false || phone_verification == null) {
                //                 _showVerificationSheet(context);
                //               } else if (address == false) {
                //                 showAddressSheet(context);
                //               } else {
                //                 OrderItem orderItem = OrderItem(
                //                 itemId: widget.item.id,
                //                 additives: itemController.getList(),
                //                 quantity: counterController.getItemCount(widget.item.supplier, widget.item.id).toString(),
                //                 price: ((widget.item.price + itemController.additiveTotal) *
                //                         counterController.getItemCount(widget.item.supplier,
                //                             widget.item.id).toDouble()).toStringAsFixed(2),
                //                 instructions: _preferences.text);
                //                 Get.to(
                //                 () => OrderPage(
                //                       item: widget.item,
                //                       supplier: supplierData,
                //                       orderItem: orderItem,
                //                     ),
                //                 transition: Transition.fade,
                //                 duration: const Duration(seconds: 1));
                //               }
                //             }
                //           },
                //           child: ReusableText(
                //               text: "Place Order",
                //               textAlign: TextAlign.center,
                //               style:
                //                   appStyle(18, kLightWhite, FontWeight.w600)),
                //         ),
                //         // CircleAvatar(
                //         //   backgroundColor: kSecondary,
                //         //   radius: 20.r,
                //         //   child: Badge(
                //         //     label: ReusableText(
                //         //         text: box.read('cart') ?? "0",
                //         //         style: appStyle(
                //         //             9, kLightWhite, FontWeight.normal)),
                //         //     child: const Icon(
                //         //       Ionicons.fast_food_outline,
                //         //       color: kLightWhite,
                //         //     ),
                //         //   ),
                //         // ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
                Positioned(
                  bottom: 0, // Positioned at the bottom of the screen
                  left: 0,
                  right: 0,
                  child: Obx(() {
                    // Only show the CartBar if items are in the cart
                    return counterController.getSupplierItemCount(widget.item.supplier) > 0
                        ? CartBar(supplierId: widget.item.supplier)
                        : const SizedBox.shrink();
                  }),
                ),
          ],
        ),
    );
  }

  Future<dynamic> _showVerificationSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        showDragHandle: true,
        barrierColor: kPrimary.withOpacity(0.2),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 500.h,
            width: width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/restaurant_bk.png",
                    ),
                    fit: BoxFit.fill),
                color: kOffWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Padding(
              padding: EdgeInsets.all(8.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  ReusableText(
                      text: "Verify Your Phone Number",
                      style: appStyle(20, kPrimary, FontWeight.bold)),
                  SizedBox(
                      height: 250.h,
                      child: ListView.builder(
                          itemCount: verificationReasons?.length ?? 0,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                verificationReasons[index],
                                textAlign: TextAlign.justify,
                                style:
                                    appStyle(11, kGrayLight, FontWeight.normal),
                              ),
                              leading: const Icon(
                                Icons.check_circle_outline,
                                color: kPrimary,
                              ),
                            );
                          })),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomButton(
                      onTap: () {
                        Get.to(() => const PhoneVerificationPage());
                      },
                      btnHieght: 40.h,
                      text: "Verify Phone Number"),
                ],
              ),
            ),
          );
        }
      );
  }
}
