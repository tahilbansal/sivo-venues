// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/cached_image_loader.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/common/shimmers/categories_shimmer.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/category_controller.dart';
import 'package:sivo_venues/hooks/fetchItemCategories.dart';
import 'package:sivo_venues/models/categories.dart';

class ItemCategoriesWidget extends HookWidget {
  final Function(String?) onCategorySelected;

  const ItemCategoriesWidget({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final hookResult = useFetchItemCategories();
    final categoryItems = hookResult.data;
    final isLoading = hookResult.isLoading;

    return isLoading
        ? const CatergoriesShimmer()
        : LayoutBuilder(
        builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.only(left: 12, top: 8),
          height: 90.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryItems?.length ?? 0,
            itemBuilder: (context, index) {
              Categories category = categoryItems[index];

              return GestureDetector(
                onTap: () {
                  if (categoryController.categoryValue == category.id) {
                    categoryController.updateCategory = '';
                    categoryController.updateTitle = '';
                    onCategorySelected(null);
                  } else if (category.value == 'more') {
                    // Get.to(() => const AllCategories(),
                    //     transition: Transition.fade,
                    //     duration: const Duration(seconds: 1));
                  } else {
                    categoryController.updateCategory = category.id;
                    categoryController.updateTitle = category.title;
                    onCategorySelected(category.id);
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
                      color: categoryController.categoryValue == category.id
                          ? kPrimary.withOpacity(0.1) // Highlight selected category
                          : Colors.transparent,
                      border: Border.all(
                        color: categoryController.categoryValue == category.id
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
                          image: category.imageUrl,
                          imageHeight: 40.w.clamp(40, 50),
                          imageWidth: 40.w.clamp(40, 50),
                        ),
                        SizedBox(height: 5.h),
                        ReusableText(
                          text: category.title,
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
