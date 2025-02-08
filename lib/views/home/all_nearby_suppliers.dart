import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/common/shimmers/itemlist_shimmer.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/hooks/fetchAllNearbySuppliers.dart';
import 'package:sivo_venues/models/suppliers.dart';
import 'package:sivo_venues/views/home/widgets/supplier_tile.dart';

class AllNearbySuppliers extends HookWidget {
  const AllNearbySuppliers({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAllSuppliers();
    final suppliers = hookResult.data;
    final isLoading = hookResult.isLoading;

    return Scaffold(
      backgroundColor: kLightWhite,
      appBar: AppBar(
        elevation: .4,
        backgroundColor: kLightWhite,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.grid_view),
          ),
        ],
        title: ReusableText(
            text: "Near by Suppliers",
            style: appStyle(12, kGray, FontWeight.w600)),
      ),
      body: isLoading
          ? const ItemsListShimmer()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              height: hieght,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: suppliers?.length ?? 0,
                  itemBuilder: (context, i) {
                    Suppliers supplier = suppliers[i];
                    return SupplierTile(supplier: supplier);
                  }),
            ),
    );
  }
}
