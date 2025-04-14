// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:sivo_venues/views/categories/more_categories.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/cached_image_loader.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/common/shimmers/categories_shimmer.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/category_controller.dart';
import 'package:sivo_venues/hooks/fetchCategories.dart';
import 'package:sivo_venues/models/categories.dart';

class CategoriesWidget extends HookWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final hookResult = useFetchCategories();
    final categoryItems = hookResult.data;
    final isLoading = hookResult.isLoading;

    return isLoading
        ? const CatergoriesShimmer()
        : LayoutBuilder(
        builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.only(left: 12, top: 8),
          height: 90.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryItems?.length ?? 0,
            itemBuilder: (context, index) {
              Categories supplierCategory = categoryItems[index];

              return GestureDetector(
                onTap: () {
                  if (categoryController.supplierCategoryValue == supplierCategory.id) {
                    categoryController.supplierUpdateCategory = '';
                    categoryController.updateTitle = '';
                  } else if (supplierCategory.value == 'more') {
                    // Get.to(() => const AllCategories(),
                    //     transition: Transition.fade,
                    //     duration: const Duration(seconds: 1));
                  } else {
                    categoryController.supplierUpdateCategory = supplierCategory.id;
                    categoryController.updateTitle = supplierCategory.title;
                  }
                },
                child: Obx(
                      () => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: 6.w),
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    width: 80.w,
                    height: 90.h,
                    decoration: BoxDecoration(
                      color: categoryController.supplierCategoryValue == supplierCategory.id
                          ? kPrimary.withOpacity(0.1) // Highlight selected category
                          : Colors.transparent,
                      border: Border.all(
                        color: categoryController.supplierCategoryValue == supplierCategory.id
                            ? kPrimary
                            : kOffWhite,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedImageLoader(
                          image: supplierCategory.imageUrl,
                          imageHeight: 40.w.clamp(40, 50),
                          imageWidth: 40.w.clamp(40, 50),
                        ),
                        SizedBox(height: 5.h),
                        ReusableText(
                          text: supplierCategory.title,
                          style: appStyle(12, kDark, FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
