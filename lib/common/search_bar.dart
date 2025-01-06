import 'package:rivus_user/common/app_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/views/search/seach_page.dart';
import 'package:get/get.dart';

class chatSearchBar extends StatelessWidget {
  const chatSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
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
                "Search Suppliers",
                style: appStyle(14, kGray, FontWeight.w400),
              ),
            ],
          ),
        ),
      );
  }
}
