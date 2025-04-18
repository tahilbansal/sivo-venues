import 'package:flutter/material.dart';
//import 'package:sivo_venues/common/middlewares/middlewares.dart';

import 'package:get/get.dart';
import 'package:sivo_venues/views/message/chat/index.dart';
import 'package:sivo_venues/views/message/photoview/index.dart';
import 'package:sivo_venues/views/message/view.dart';
import '../../views/auth/login_page.dart';
import '../../views/auth/verification_page.dart';
import '../../views/entrypoint.dart';
import '../../views/orders/client_orders.dart';
import '../../views/orders/order_details_page.dart';
import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static const APPlication = AppRoutes.Application;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    /*
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
      middlewares: [
        RouteWelcomeMiddleware(priority: 1)
      ]
    ),
    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => const SignInPage(),
      binding: SignInBinding(),
    ),

    // check if needed to login or not
    GetPage(
      name: AppRoutes.Application,
      page: () => ApplicationPage(),
      binding: ApplicationBinding(),
      middlewares: [
       // RouteAuthMiddleware(priority: 1),
      ],
    ),

    // 最新路由
    // 首页
    GetPage(
        name: AppRoutes.Contact,
        page: () => const ContactPage(),
        binding: ContactBinding()),*/
    /*
    GetPage(name: AppRoutes.Message, page: () => MessagePage(), binding: MessageBinding()),
    */
    /* GetPage(name: AppRoutes.Me,
        page: () => const ProfilePage(),
        binding: ProfileBinding()),
*/

    GetPage(
        name: AppRoutes.INITIAL,
        page: () =>  MainScreen(),
    ),
    GetPage(name: AppRoutes.login,
        page: () => Login()),

    GetPage(name: AppRoutes.verification,
        page: () => VerificationPage()),

    GetPage(
      name: AppRoutes.OrderDetails,
      page: () => OrderDetailsPage(orderId: Get.parameters['orderId']!),
    ),

    GetPage(
        name: AppRoutes.Chat,
        page: () => const ChatPage(),
        binding: ChatBinding()),

    GetPage(
        name: AppRoutes.Photoimgview,
        page: () => const PhotoImageView(),
        binding: PhotoImageViewBinding()),

    GetPage(
      name: AppRoutes.main,
      page: () => MainScreen(),
    ),
    GetPage(
      name: AppRoutes.Message,
      page: () => MainScreen(),
      transition: Transition.noTransition,
      arguments: 1,
    ),
    GetPage(
      name: AppRoutes.Orders,
      page: () => MainScreen(),
      transition: Transition.noTransition,
      arguments: 2,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => MainScreen(),
      transition: Transition.noTransition,
      arguments: 3,
    ),

  ];
}
