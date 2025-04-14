import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/custom_container.dart';
import 'package:sivo_venues/common/customer_service.dart';
import 'package:sivo_venues/constants/constants.dart';
//import 'package:sivo_venues/controllers/feedback_controller.dart';
import 'package:sivo_venues/controllers/login_controller.dart';
import 'package:sivo_venues/hooks/fetchServiceNumber.dart';
import 'package:sivo_venues/models/login_response.dart';
import 'package:sivo_venues/views/auth/widgets/login_redirect.dart';
import 'package:sivo_venues/views/message/index.dart';
import 'package:sivo_venues/views/orders/client_orders.dart';
import 'package:sivo_venues/views/profile/address.dart';
import 'package:sivo_venues/views/profile/widgets/profile_appbar.dart';
import 'package:sivo_venues/views/profile/widgets/tile_widget.dart';
//import 'package:sivo_venues/views/reviews/rating_review_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../message/view.dart';

class ProfilePage extends HookWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    //final upload = Get.put(UserFeedBackController());
    LoginResponse? user;
    final box = GetStorage();
    String? token = box.read('token');

    final controller = Get.put(LoginController());

    if (token != null) {
      user = controller.getUserData();
    }

    final serviceNumber = useFetchCustomerService();

    return token == null
        ? const LoginRedirection()
        : Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.h),
                child: const ProfileAppBar()),
            body: SafeArea(
              child: CustomContainer(
                  containerContent: Column(
                children: [
                  Container(
                    height: height * 0.06,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 0, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade100,
                                      backgroundImage:
                                          NetworkImage(user!.profile),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.username,
                                          style: appStyle(
                                              12, kGray, FontWeight.w600),
                                        ),
                                        Text(
                                          user.email,
                                          style: appStyle(
                                              11, kGray, FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 12.0.h),
                                    child: const Icon(Feather.edit, size: 18),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100.h,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        TilesWidget(
                          onTap: () {
                            Get.to(() => const ClientOrderPage(),
                                transition: Transition.fade,
                                duration: const Duration(seconds: 1));
                          },
                          title: "My Orders",
                          leading: Ionicons.cart_outline,
                        ),
                        TilesWidget(
                          onTap: () {
                            //Get.to(() => const RatingReview());
                          },
                          title: "Reviews and rating",
                          leading: Ionicons.chatbubble_ellipses_outline,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 150.h,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        TilesWidget(
                          onTap: () {
                            Get.to(() => const Addresses(),
                                transition: Transition.fade,
                                duration: const Duration(seconds: 1));
                          },
                          title: "Shipping addresses",
                          leading: SimpleLineIcons.location_pin,
                        ),
                        TilesWidget(
                          onTap: () {
                            customerService(context, serviceNumber);
                          },
                          title: "Service Center",
                          leading: AntDesign.customerservice,
                        ),
                        // TilesWidget(
                        //   title: "App Feedback",
                        //   leading: MaterialIcons.rss_feed,
                        //   onTap: () {
                        //     BetterFeedback.of(context)
                        //         .show((UserFeedback feedback) async {
                        //       var url = feedback.screenshot;
                        //       upload.feedbackFile.value = await upload
                        //           .writeBytesToFile(url, "feedback");
                        //
                        //       String message = feedback.text;
                        //       upload.uploadImageToFirebase(message);
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  Container(
                    height: 45.h,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        TilesWidget(
                          onTap: () {
                            Get.to(() => const MessagePage(),
                                transition: Transition.fade,
                                duration: const Duration(seconds: 1));
                          },
                          title: "Chats",
                          leading: SimpleLineIcons.speech,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ),
          );
  }
}
