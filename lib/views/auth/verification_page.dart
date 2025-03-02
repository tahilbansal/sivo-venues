import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/email_verification_controller.dart';
import 'package:sivo_venues/controllers/login_controller.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sivo_venues/models/login_response.dart';
import 'package:sivo_venues/views/home/widgets/custom_btn.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmailVerificationController());
    final userController = Get.put(LoginController());
    LoginResponse? user = userController.getUserData();

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          SizedBox(
            height: 100.h,
          ),
          Lottie.asset('assets/anime/sivo_animation.json'),
          SizedBox(
            height: 30.h,
          ),
          ReusableText(
              text: "Verify Your Account",
              style: appStyle(20, kPrimary, FontWeight.bold)),
          Text(
              "Enter the code sent to your email, if you did not send recieve the code, click resend",
              style: appStyle(10, kGrayLight, FontWeight.normal)),
          SizedBox(
            height: 20.h,
          ),
          OtpTextField(
            numberOfFields: 6,
            borderColor: kPrimary,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            focusedBorderColor: kSecondary,
            textStyle: appStyle(17, kDark, FontWeight.bold),
            showFieldAsBox: false,
            borderWidth: 2.0,
            onSubmit: (String verificationCode) {
              controller.code = verificationCode;
            },
          ),
          SizedBox(
            height: 20.h,
          ),
          CustomButton(
            onTap: () {
              controller.verifyEmail();
            },
            color: kPrimary,
            text: "Verify Account",
            btnHieght: 40.h,
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
              "The email has been sent to ${user!.email}. If the email is correct, please delete this account and create a new one with the correct email. Alternatively, you can logout and browser the app without an account.",
              textAlign: TextAlign.justify,
              style: appStyle(10, kGray, FontWeight.normal)),
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    userController.logout();
                  },
                  child: ReusableText(
                      text: "Logout",
                      style: appStyle(12, kSecondary, FontWeight.w600))),
              GestureDetector(
                onTap: () {
                  userController.deleteAccount();
                },
                child: ReusableText(
                    text: "Delete account",
                    style: appStyle(12, kRed, FontWeight.w600)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
