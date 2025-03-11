import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sivo_venues/common/custom_container.dart';
import 'package:sivo_venues/common/custom_textfield.dart';
import 'package:sivo_venues/common/shimmers/itemlist_shimmer.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/search_controller.dart';
import 'package:sivo_venues/views/search/catalog_search_results.dart';
import 'package:sivo_venues/views/search/search_results.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CatalogSearchPage extends StatefulWidget {
  const CatalogSearchPage({super.key, required this.supplierId});

  final String supplierId;

  @override
  State<CatalogSearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<CatalogSearchPage> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments['focus'] == true) {
        focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(ItemSearchController());
    return Obx(() => Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        toolbarHeight: 74.h,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: kOffWhite,
        title: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: kPrimary),
                onPressed: () {
                  Get.back();
                },
              ),
              Expanded(
                child: CustomTextField(
                  controller: controller,
                  hintText: "Search Catalog",
                  keyboardType: TextInputType.text,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      searchController.searchCatalogItems(widget.supplierId ,controller.text);
                    },
                    child: Icon(
                      Ionicons.search_circle,
                      size: 36.h,
                      color: kPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomContainer(
          containerContent: Column(
            children: [
              searchController.isLoading
                  ? const ItemsListShimmer()
                  : searchController.itemsResults == null
                  ? const LoadingWidget()
                  : const CatalogSearchResults(),
            ],
          )
      ),
    ));
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))),
      child: Padding(
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
