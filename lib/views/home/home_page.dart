import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivus_user/common/custom_appbar.dart';
import 'package:rivus_user/common/custom_container.dart';
import 'package:rivus_user/common/heading.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/controllers/category_controller.dart';
import 'package:rivus_user/controllers/counter_controller.dart';
import 'package:rivus_user/views/home/all_nearby_suppliers.dart';
import 'package:rivus_user/views/home/fastest_foods_page.dart';
import 'package:rivus_user/views/home/recommendations.dart';
import 'package:rivus_user/views/home/widgets/categories_list.dart';
import 'package:rivus_user/views/home/widgets/category_Supplierlist.dart';
import 'package:rivus_user/views/home/widgets/food_list.dart';
import 'package:rivus_user/views/home/widgets/nearby_suppliers.dart';
import 'package:get/get.dart';

import '../../common/app_style.dart';
import '../search/seach_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final CounterController counterController = Get.put(CounterController());
    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(130.h), child: const CustomAppBar()),
      body: SafeArea(
          child: CustomContainer(
              containerContent: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => const SearchPage(), arguments: {'focus': true});
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: kGray),
                  SizedBox(width: 8.w),
                  Text(
                    "Search for Supplier",
                    style: appStyle(14, kGray, FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          const CategoriesWidget(),
          Obx(
            () => categoryController.categoryValue == ''
                ? Column(
                    children: [
                      HomeHeading(
                        heading: "Suppliers",
                        onTap: () {
                          Get.to(() => const AllNearbySuppliers());
                        },
                      ),
                      const NearbySuppliers(),
                      HomeHeading(
                        heading: "Try Something New",
                        onTap: () {
                          //Get.to(() => const Recommendations());
                        },
                      ),
                      //const FoodList(),
                    ],
                  )
                : CustomContainer(
                    containerContent: Column(
                      children: [
                        HomeHeading(
                          heading:
                              "Explore ${categoryController.titleValue} Category",
                          restaurant: true,
                        ),
                        const CategorySupplierList(),
                      ],
                    ),
                  ),
          ),
        ],
      ))),
    );
  }
}
