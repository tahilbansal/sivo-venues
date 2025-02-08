// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sivo_venues/common/app_style.dart';
// import 'package:sivo_venues/common/cached_image_loader.dart';
// import 'package:sivo_venues/common/reusable_text.dart';
// import 'package:sivo_venues/constants/constants.dart';
//
// class FoodWidget extends StatelessWidget {
//      FoodWidget(
//       {super.key,
//       required this.image,
//       required this.title,
//       required this.time,
//       this.onTap, required this.price});
//
//   final String image;
//   final String title;
//   final String price;
//   final String time;
//   final void Function()? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 12),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: width * 0.75,
//           height: 180.h,
//           decoration: const BoxDecoration(
//               color: kLightWhite,
//               borderRadius: BorderRadius.all(Radius.circular(12))),
//           child: ListView(
//             padding: EdgeInsets.zero,
//             physics: const NeverScrollableScrollPhysics(),
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.all(Radius.circular(12)),
//                   child: CachedImageLoader(image: image, imageHeight: 114.h,imageWidth: width*0.8,),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ReusableText(
//                             text: title,
//                             style: appStyle(12, kDark, FontWeight.w500)),
//
//                             ReusableText(
//                             text: "\$ $price",
//                             style: appStyle(12, kPrimary, FontWeight.w500)),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ReusableText(
//                             text: "Delivery time",
//                             style: appStyle(9, kGray, FontWeight.w500)),
//                         ReusableText(
//                             text: time,
//                             style: appStyle(9, kGray, FontWeight.w500)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
