// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/divida.dart';
import 'package:sivo_venues/common/not_found.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/common/show_snack_bar.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/address_controller.dart';
import 'package:sivo_venues/controllers/contact_controller.dart';
import 'package:sivo_venues/controllers/location_controller.dart';
import 'package:sivo_venues/models/distance_time.dart';
import 'package:sivo_venues/models/response_model.dart';
import 'package:sivo_venues/models/suppliers.dart';
import 'package:sivo_venues/services/distance.dart';
import 'package:sivo_venues/views/auth/login_page.dart';
import 'package:sivo_venues/views/home/widgets/custom_btn.dart';
//import 'package:sivo_venues/views/supplier/directions_page.dart';
//import 'package:sivo_venues/views/supplier/rating_page.dart';
//import 'package:sivo_venues/views/supplier/widgets/explore.dart';
import 'package:sivo_venues/views/supplier/widgets/catalog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:glass/glass.dart';
import 'package:sivo_venues/views/supplier/widgets/catalog_search.dart';
import 'package:sivo_venues/views/supplier/widgets/filter_categories_model.dart';
import 'package:sivo_venues/views/supplier/widgets/my_catalog.dart';
import 'package:sivo_venues/views/supplier/widgets/top_bar.dart';

import '../../controllers/counter_controller.dart';
import '../../controllers/item_controller.dart';
import '../cart/widgets/cart_bar.dart';
import 'directions_page.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key, required this.supplier});

  final Suppliers supplier;

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> with TickerProviderStateMixin {
  final scrollToCategoryNotifier = ValueNotifier<String?>(null);
  late TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );
  final box = GetStorage();
  final controller = Get.put(AddressController());
  final location = Get.put(UserLocationController());
  final CounterController counterController = Get.put(CounterController());
  String accessToken = "";
  late DistanceTime distanceTime;
  final ContactController _controller = Get.put(ContactController());

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
    String? token = box.read('token');

    if (token != null) {
      accessToken = jsonDecode(token);
      if (controller.defaultAddress != null) {
        distanceTime = Distance().calculateDistanceTimePrice(
          controller.defaultAddress!.latitude,
          controller.defaultAddress!.longitude,
          widget.supplier.coords.latitude,
          widget.supplier.coords.longitude,
          10,
          2.00,
        );
      } else {
        // Handle the case where defaultAddress is null
        distanceTime = Distance().calculateDistanceTimePrice(
          location.currentLocation.latitude,
          location.currentLocation.longitude,
          widget.supplier.coords.latitude,
          widget.supplier.coords.longitude,
          10,
          2.00,
        );
      }
    } else {
      distanceTime = Distance().calculateDistanceTimePrice(
          location.currentLocation.latitude,
          location.currentLocation.longitude,
          widget.supplier.coords.latitude,
          widget.supplier.coords.longitude,
          10,
          2.00);
    }

    loadChatData();
    _controller.state.ownerId.value = widget.supplier.owner;
    _controller.state.supplierId.value = widget.supplier.id!;

    // String numberString = widget.supplier.time.substring(0, 2);
    double totalTime = 25 + distanceTime.time;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kOffWhite,
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Supplier image and top bar
                Stack(
                  children: [
                    SizedBox(
                      height: 200.h,
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.supplier.imageUrl!,
                      ),
                    ),
                    // Container(
                    //   height: 180.h,
                    //   width: MediaQuery.of(context).size.width,
                    //   color: Colors.black.withOpacity(0.4),
                    // ),
                    // Top bar overlay
                    Positioned.fill(
                      child: SupplierTopBar(
                        title: widget.supplier.title!,
                        supplier: widget.supplier,
                      ),
                    ),
                    Positioned(
                      bottom: 12.h,
                      left: 0,
                      right: 10.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          onTap: () async {
                            if (widget.supplier == null) {
                              Get.to(
                                      () => const NotFoundPage(
                                    text: "Can not open supplier page",),
                                  transition: Transition.fade,
                                  duration: const Duration(seconds: 1),
                                  arguments: {});
                            } else {
                              ResponseModel status = await _controller.goChat(widget.supplier);
                              if (status.isSuccess == false) {
                                showCustomSnackBar(status.message!, title: status.title!);
                              }
                            }
                          },
                          radius: 30,
                          color: kPrimary,
                          btnHieght: 34.h,
                          btnWidth: width * 0.3,
                          text: "Message",
                        ),
                      ],
                    ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // CustomButton(
                    //   onTap: () async {
                    //     // Add your logic to move supplier to wishlist
                    //     //ResponseModel status = await _controller.addToWishlist(widget.supplier);
                    //   },
                    //   radius: 9,
                    //   color: Colors.grey, // Customize the color
                    //   btnWidth: MediaQuery.of(context).size.width *
                    //       0.45, // Half width minus padding
                    //   btnHieght: 34.h,
                    //   text: "Add to Wishlist",
                    // ),
                    const SizedBox(width: 18),
                    ReusableText(
                        text: widget.supplier.title!,
                        style: appStyle(18, kDark, FontWeight.w600)),
                    const SizedBox(width: 5),
                    // CustomButton(
                    //   onTap: () async {
                    //     if (widget.supplier == null) {
                    //       Get.to(
                    //           () => const NotFoundPage(
                    //                 text: "Can not open supplier page",),
                    //           transition: Transition.fade,
                    //           duration: const Duration(seconds: 1),
                    //           arguments: {});
                    //     } else {
                    //       ResponseModel status = await _controller.goChat(widget.supplier);
                    //       if (status.isSuccess == false) {
                    //         showCustomSnackBar(status.message!, title: status.title!);
                    //       }
                    //     }
                    //   },
                    //   radius: 9,
                    //   color: kPrimary,
                    //   btnHieght: 34.h,
                    //   btnWidth: width * 0.6,
                    //   text: "Message Supplier",
                    // ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                  child: Divider(
                    color: kGrayLight,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: SizedBox(
                    height: 25.h,
                    width: MediaQuery.of(context).size.width,
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelPadding: EdgeInsets.zero,
                      labelColor: Colors.white,
                      dividerColor: Colors.transparent,
                      labelStyle: appStyle(12, kLightWhite, FontWeight.normal),
                      unselectedLabelColor: Colors.grey.withOpacity(0.7),
                      tabs: const <Widget>[
                        Tab(child: Center(child: Text("Catalog"))),
                        Tab(child: Center(child: Text("My Catalog"))),
                      ],
                    ),
                  ).asGlass(
                      tintColor: kPrimary,
                      clipBorderRadius: BorderRadius.circular(19.0),
                      blurX: 8,
                      blurY: 8),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: catalogSearchBar(supplierId: widget.supplier.id!)),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () async {
                        final selectedCategory = await showModalBottomSheet<String?>(
                          context: context,
                          builder: (context) => const FilterCategoriesModal(),
                        );

                        // Update the notifier to scroll to the selected category
                        if (selectedCategory != null) {
                          scrollToCategoryNotifier.value = selectedCategory;
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SupplierCatalog(supplierId: widget.supplier.id!, heightFactor: 0.62, scrollToCategory: scrollToCategoryNotifier,),
                      MyCatalog(supplierId: widget.supplier.id!),
                    ],
                  ),
                ),
              ],
            ),
            // Use the CartBar widget at the bottom of the screen
            Positioned(
              bottom: 0, // Positioned at the bottom of the screen
              left: 0,
              right: 0,
              child: Obx(() {
                // Only show the CartBar if items are in the cart
                return counterController.getSupplierItemCount(widget.supplier.id!) > 0
                    ? CartBar(supplierId: widget.supplier.id!)
                    : const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class SupplierRatingBar extends StatelessWidget {
  const SupplierRatingBar({
    super.key,
    required this.supplier,
  });

  final Suppliers supplier;

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read("token");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35.h,
      decoration: BoxDecoration(
        color: kPrimary.withOpacity(0.5),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.r), topRight: Radius.circular(6.r)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
              onTap: () {
                if (token == null) {
                  Get.to(() => const Login(),
                      transition: Transition.fadeIn,
                      duration: const Duration(seconds: 2));
                } else {
                  // Get.to(() => RatingPage(
                  //       supplier: supplier,
                  //     ));
                }
              },
              text: "Rate Supplier",
              btnWidth: width / 3,
            )
          ],
        ),
      ),
    );
  }
}

class RowText extends StatelessWidget {
  const RowText({
    super.key,
    required this.first,
    required this.second,
  });

  final String first;
  final String second;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReusableText(text: first, style: appStyle(10, kGray, FontWeight.w500)),
        Flexible(
            child: Text(second,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: appStyle(10, kGray, FontWeight.w400))
        )
      ],
    );
  }
}
