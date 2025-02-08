import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_venues/common/custom_appbar.dart';
import 'package:sivo_venues/common/custom_container.dart';
import 'package:sivo_venues/common/heading.dart';
import 'package:sivo_venues/common/search_bar.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/category_controller.dart';
import 'package:sivo_venues/controllers/counter_controller.dart';
import 'package:sivo_venues/views/home/all_nearby_suppliers.dart';
import 'package:sivo_venues/views/home/fastest_foods_page.dart';
import 'package:sivo_venues/views/home/recommendations.dart';
import 'package:sivo_venues/views/home/widgets/categories_list.dart';
import 'package:sivo_venues/views/home/widgets/category_Supplierlist.dart';
import 'package:sivo_venues/views/home/widgets/food_list.dart';
import 'package:sivo_venues/views/home/widgets/nearby_suppliers.dart';
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
          preferredSize: Size.fromHeight(80.h), child: const CustomAppBar()),
      body: SafeArea(
        child: CustomContainer(
        containerContent: Column(
        children: [
          chatSearchBar(),
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
                  const NearbySuppliers(),
                  //const ItemList(),
                ],
              )
              : CustomContainer(
                  containerContent: Column(
                    children: [
                      HomeHeading(
                        heading: "Explore ${categoryController.titleValue} Category",
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
