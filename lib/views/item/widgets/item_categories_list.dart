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
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
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
                  // Navigate to more categories screen if implemented
                } else {
                  categoryController.updateCategory = category.id;
                  categoryController.updateTitle = category.title;
                  onCategorySelected(category.title);
                }
              },
              child: Obx(
                    () => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: categoryController.categoryValue == category.id
                        ? kPrimary.withOpacity(0.1)
                        : Colors.white,
                    border: Border.all(
                      color: categoryController.categoryValue == category.id
                          ? kPrimary
                          : kOffWhite,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CachedImageLoader(
                        image: category.imageUrl,
                        imageHeight: 40,
                        imageWidth: 40,
                      ),
                      const SizedBox(height: 6),
                      Flexible(
                        child: ReusableText(
                          text: category.title,
                          style: appStyle(12, kDark, FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}