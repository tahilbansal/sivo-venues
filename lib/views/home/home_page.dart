import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/common/custom_appbar.dart';
import 'package:sivo_venues/common/custom_container.dart';
import 'package:sivo_venues/common/heading.dart';
import 'package:sivo_venues/common/search_bar.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/category_controller.dart';
import 'package:sivo_venues/views/home/all_nearby_suppliers.dart';
import 'package:sivo_venues/views/home/widgets/categories_list.dart';
import 'package:sivo_venues/views/home/widgets/category_Supplierlist.dart';
import 'package:sivo_venues/views/home/widgets/nearby_suppliers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h), child: const CustomAppBar()),
      body: SafeArea(
        child: CustomContainer(
        containerContent: Column(
        children: [
          const chatSearchBar(),
          const CategoriesWidget(),
          Obx(
            () => categoryController.supplierCategoryValue == ''
            ? Column(
                children: [
                  HomeHeading(
                    heading: "Near by Suppliers",
                    onTap: () {
                      Get.to(() => const AllNearbySuppliers());
                    },
                  ),
                  const NearbySuppliers(),
                  HomeHeading(
                    heading: "Recommended Suppliers",
                    onTap: () {
                      Get.to(() => const AllNearbySuppliers());
                    },
                  ),
                  const NearbySuppliers(),
                  // const ItemList(),
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
