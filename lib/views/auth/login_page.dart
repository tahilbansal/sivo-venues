import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/login_controller.dart';
import 'package:sivo_venues/models/login_request.dart';
import 'package:sivo_venues/views/auth/registration.dart';
import 'package:sivo_venues/views/auth/widgets/email_textfield.dart';
import 'package:sivo_venues/views/auth/widgets/password_field.dart';
import 'package:sivo_venues/views/home/widgets/custom_btn.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final controller = Get.put(LoginController());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Sivo",
          style: appStyle(26, kPrimary, FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/anime/sivo_animation.json', height: 200.h),
                      SizedBox(height: 30.h),
                      _buildEmailField(),
                      SizedBox(height: 20.h),
                      _buildPasswordField(),
                      SizedBox(height: 10.h),
                      _buildRegisterLink(),
                      SizedBox(height: 30.h),
                      _buildLoginButton(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return EmailTextField(
      hintText: "Email",
      controller: _emailController,
      prefixIcon: Icon(CupertinoIcons.mail, color: kGrayLight, size: 18.sp.clamp(18, 28)),
      keyboardType: TextInputType.emailAddress,
      onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocusNode),
    );
  }

  Widget _buildPasswordField() {
    return PasswordField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
    );
  }

  Widget _buildRegisterLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => Get.to(() => const RegistrationPage()),
        child: Text(
          'Register',
          style: appStyle(14.sp.clamp(14, 14), kPrimary, FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(() => controller.isLoading
        ? CircularProgressIndicator(color: kPrimary)
        : CustomButton(
      btnHieght: 50.h,
      color: kPrimary,
      text: "LOGIN",
      onTap: () {
        LoginRequest model = LoginRequest(
          email: _emailController.text,
          password: _passwordController.text,
        );
        String authData = loginRequestToJson(model);
        controller.loginFunc(authData, model);
      },
    ));
  }
}

