import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/common/show_snack_bar.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/contact_controller.dart';
import 'package:sivo_venues/models/response_model.dart';
import 'package:sivo_venues/models/suppliers.dart';
import 'package:sivo_venues/views/supplier/suppliers_page.dart';

class SupplierTile extends StatelessWidget {
  const SupplierTile({
    Key? key,
    required this.supplier,
  }) : super(key: key);

  final Suppliers supplier;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => SupplierPage(supplier: supplier),
          transition: Transition.native,
          duration: const Duration(milliseconds: 300)),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: kLightWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: kGray.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildSupplierImage(),
            SizedBox(width: 12.w),
            Expanded(child: _buildSupplierInfo()),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Image.network(
        supplier.imageUrl!,
        height: 70.h,
        width: 70.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSupplierInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
          text: supplier.title!,
          style: appStyle(14, kDark, FontWeight.w500),
        ),
        SizedBox(height: 4.h),
        ReusableText(
          text: "Delivery time: ${supplier.time}",
          style: appStyle(12, kGray, FontWeight.w400),
        ),
        SizedBox(height: 4.h),
        ReusableText(
          text: supplier.coords.address,
          style: appStyle(12, kGray, FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
          text: "Chat",
          color: kPrimary,
          onTap: () async {
            ResponseModel status = await Get.find<ContactController>().goChat(supplier);
            if (!status.isSuccess) {
              showCustomSnackBar(status.message!, title: status.title!);
            }
          },
        ),
        // SizedBox(height: 8.h),
        // _buildButton(
        //   icon: Icons.shopping_cart_outlined,
        //   color: kSecondary,
        //   onTap: () {
        //     // Implement shopping action
        //   },
        // ),
      ],
    );
  }

  Widget _buildButton({String? text, IconData? icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: text != null
            ? ReusableText(
          text: text,
          style: appStyle(12, kLightWhite, FontWeight.bold),
        )
            : Icon(icon, size: 18.sp, color: kLightWhite),
      ),
    );
  }
}

