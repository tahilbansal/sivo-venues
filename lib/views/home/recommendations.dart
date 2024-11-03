// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rivus_user/common/app_style.dart';
// import 'package:rivus_user/common/reusable_text.dart';
// import 'package:rivus_user/common/shimmers/itemlist_shimmer.dart';
// import 'package:rivus_user/constants/constants.dart';
// import 'package:rivus_user/hooks/fetchRecommendations.dart';
// import 'package:rivus_user/models/foods.dart';
// import 'package:rivus_user/views/food/widgets/supplier_tile.dart';
//
// class Recommendations extends HookWidget {
//   const Recommendations({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final hookResult = useFetchRecommendations("41007428", true);
//     final foods = hookResult.data;
//     final isLoading = hookResult.isLoading;
//
//     return Scaffold(
//       backgroundColor: kLightWhite,
//       appBar: AppBar(
//         elevation: .4,
//         centerTitle: true,
//         backgroundColor: kLightWhite,
//          actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.grid_view),
//           ),
//         ],
//         title: ReusableText(
//             text: "Recommendations", style: appStyle(12, kGray, FontWeight.w600)),
//       ),
//       body: isLoading
//           ? const FoodsListShimmer()
//           : Container(
//               padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
//               height: hieght,
//               child: ListView.builder(
//                   padding: EdgeInsets.zero,
//                   itemCount: foods?.length ??0,
//                   itemBuilder: (context, i) {
//                     Food food = foods[i];
//                     return FoodTile(food: food);
//                   }),
//             ),
//     );
//
//   }
// }
