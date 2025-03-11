import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/search_controller.dart';
import 'package:sivo_venues/models/items.dart';
import 'package:sivo_venues/views/item/widgets/item_tile.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../models/suppliers.dart';
import '../home/widgets/supplier_tile.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(ItemSearchController());
    return Container(
      color: searchController.itemsResults!.isEmpty ||
              searchController.itemsResults == null ||
              searchController.suppliersResults!.isEmpty
          ? kLightWhite
          : Colors.white,
      padding: EdgeInsets.only(left: 12.w, top: 10.h, right: 12.w),
      height: height,
      child: searchController.itemsResults!.isNotEmpty ||
              searchController.suppliersResults!.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.zero,
              itemCount: searchController.itemsResults!.length +
                  searchController.suppliersResults!.length,
              itemBuilder: (context, index) {
                if (index < searchController.itemsResults!.length) {
                  // Display items
                  Item item = searchController.itemsResults![index];
                  return ItemTile(item: item);
                } else {
                  // Display suppliers
                  Suppliers supplier = searchController.suppliersResults![
                      index - searchController.itemsResults!.length];
                  return SupplierTile(supplier: supplier);
                }
              })
          : Padding(
              padding: EdgeInsets.only(bottom: 180.0.h),
              child: LottieBuilder.asset(
                "assets/anime/sivo_animation.json",
                width: width,
                height: height / 2,
              ),
            ),
    );
  }
}
