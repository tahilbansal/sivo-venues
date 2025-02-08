import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/cached_image_loader.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/constants/constants.dart';

class SupplierWidget extends StatelessWidget {
  const SupplierWidget(
      {super.key,
      required this.image,
      required this.logo,
      required this.title,
      required this.time,
      this.onTap,
      required this.rating});

  final String image;
  final String logo;
  final String title;
  final String time;
  final String rating;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          width: width * 0.75,
          height: 200.h,
          decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: kGrayLight,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
        ),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: CachedImageLoader(
                          image: image,
                          imageHeight: 120.h,
                          imageWidth: width * 0.8,
                        )),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50.r)),
                        child: Container(
                          color: kLightWhite,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.r)),
                              child: Image.network(
                                logo,
                                fit: BoxFit.cover,
                                height: 20.h,
                                width: 20.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                        text: title,
                        style: appStyle(12, kDark, FontWeight.w500)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                            text: "Delivery under",
                            style: appStyle(9, kGray, FontWeight.w500)),
                        ReusableText(
                            text: time,
                            style: appStyle(9, kGray, FontWeight.w500)),
                      ],
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: 5,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: kPrimary,
                          ),
                          itemCount: 5,
                          itemSize: 15.0,
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ReusableText(
                            text: rating,
                            style: appStyle(9, kGray, FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
