import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/registration_controller.dart';
import 'package:sivo_venues/models/registration.dart';
import 'package:sivo_venues/views/auth/widgets/email_textfield.dart';
import 'package:sivo_venues/views/auth/widgets/password_field.dart';
import 'package:sivo_venues/views/home/widgets/custom_btn.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final _registrationFormKey = GlobalKey<FormState>();
  final controller = Get.put(RegistrationController());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    final form = _registrationFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Sivo",
          style: appStyle(30, kPrimary, FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Lottie.asset('assets/anime/sivo_animation.json', height: 200.h),
                SizedBox(height: 20.h),
                Form(
                  key: _registrationFormKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _usernameController,
                        hintText: "Username",
                        icon: CupertinoIcons.person,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 15.h),
                      _buildTextField(
                        controller: _emailController,
                        hintText: "Email",
                        icon: CupertinoIcons.mail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 15.h),
                      PasswordField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                      ),
                      SizedBox(height: 20.h),
                      _buildRegisterButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return EmailTextField(
      hintText: hintText,
      controller: controller,
      prefixIcon: Icon(icon, color: kGrayLight, size: 20.sp.clamp(20,30)),
      keyboardType: keyboardType,
    );
  }

  Widget _buildRegisterButton() {
    return Obx(() => controller.isLoading
        ? const CircularProgressIndicator(color: kPrimary)
        : CustomButton(
      btnHieght: 50.h,
      color: kPrimary,
      text: "REGISTER",
      onTap: () {
        if (validateAndSave()) {
          Registration model = Registration(
            username: _usernameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
          String userdata = registrationToJson(model);
          controller.registration(userdata);
        }
      },
    ));
  }
}

