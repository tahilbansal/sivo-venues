import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/tab_controller.dart';
import 'package:sivo_venues/hooks/fetchDefaultAddress.dart';
import 'package:sivo_venues/views/home/home_page.dart';
import 'package:sivo_venues/views/message/view.dart';
import 'package:sivo_venues/views/profile/profile_page.dart';

import 'orders/client_orders.dart';

// ignore: must_be_immutable
class MainScreen extends HookWidget {
  MainScreen({Key? key}) : super(key: key);

  final box = GetStorage();

  List<Widget> pageList = <Widget>[
    const HomePage(),
    const MessagePage(),
    const ClientOrderPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('token');
    bool? verification = box.read("verification");
    if (token != null && verification == false) {
    } else if (token != null && verification == true) {
      useFetchDefault(context, true);
    }
    final entryController = Get.put(MainScreenController());

    // Use the argument to set tabIndex and control loading
    final args = Get.arguments;
    if (args != null && args is int) {
      Future.delayed(const Duration(milliseconds: 50), () {
        entryController.setTabIndex = args;
      });
    }
    return Obx(() => Scaffold(
      body: Stack(
        children: [
          pageList[entryController.tabIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Theme(
              data: Theme.of(context).copyWith(canvasColor: kPrimary),
              child: BottomNavigationBar(
                  selectedFontSize: 12,
                  backgroundColor: kPrimary,
                  elevation: 0,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  unselectedIconTheme: const IconThemeData(color: Colors.black38),
                  items: [
                    BottomNavigationBarItem(
                      icon: entryController.tabIndex == 0
                          ? const Icon(
                        AntDesign.appstore1,
                        color: kSecondary,
                        size: 24,
                      )
                          : const Icon(AntDesign.appstore1),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: entryController.tabIndex == 1
                          ? const Icon(
                        Ionicons.chatbubble_ellipses,
                        color: kSecondary,
                        size: 28,
                      )
                          : const Icon(Ionicons.chatbubble_ellipses),
                      label: 'Inbox',
                    ),
                    BottomNavigationBarItem(
                      icon: entryController.tabIndex == 2
                          ? Badge(
                          label: ReusableText(
                              text: box.read('cart') ?? "0",
                              style: appStyle(8, kLightWhite, FontWeight.normal)),
                          child: const Icon(
                            FontAwesome.truck,
                            color: kSecondary,
                            size: 24,
                          ))
                          : Badge(
                        label: ReusableText(
                            text: box.read('cart') ?? "0",
                            style: appStyle(8, kLightWhite, FontWeight.normal)),
                        child: const Icon(FontAwesome.truck,),
                      ),
                      label: 'Orders',
                    ),
                    BottomNavigationBarItem(
                      icon: entryController.tabIndex == 3
                          ? const Icon(
                        FontAwesome.user_circle_o,
                        color: kSecondary,
                        size: 24,
                      )
                          : const Icon(
                        FontAwesome.user_circle_o,
                      ),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: entryController.tabIndex,
                  unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                  selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
                  onTap: ((value) {
                    entryController.setTabIndex = value;
                    // Navigate to the corresponding page using Get.toNamed
                    // switch (value) {
                    //   case 0:
                    //     Get.toNamed(AppRoutes.main); // HomePage route
                    //     break;
                    //   case 1:
                    //     Get.toNamed(AppRoutes.Message); // MessagePage route
                    //     break;
                    //   case 2:
                    //     Get.toNamed(AppRoutes.Orders); // ClientOrderPage route
                    //     break;
                    //   case 3:
                    //     Get.toNamed(AppRoutes.profile); // ProfilePage route
                    //     break;
                    //   default:
                    //     break;
                    // }

                  })),
            ),
          ),
        ],
      ),
    ));
  }
}
