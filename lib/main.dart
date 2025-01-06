import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/controllers/cart_controller.dart';
import 'package:rivus_user/firebase_options.dart';
import 'package:rivus_user/models/environment.dart';
import 'package:rivus_user/services/notification_service.dart';
import 'package:rivus_user/views/auth/login_page.dart';
import 'package:rivus_user/views/auth/phone_verification.dart';
import 'package:rivus_user/views/auth/verification_page.dart';
import 'package:rivus_user/views/entrypoint.dart';
import 'package:rivus_user/views/home/home_page.dart';
import 'package:rivus_user/views/message/chat/index.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rivus_user/views/message/controller.dart';
import 'package:rivus_user/views/message/view.dart';
import 'package:rivus_user/views/orders/order_details_page.dart';
import 'package:rivus_user/views/orders/order_notification_details_page.dart';

import 'common/routes/pages.dart';
import 'controllers/contact_controller.dart';

import 'controllers/counter_controller.dart';
import 'controllers/login_controller.dart';

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print("onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: Environment.fileName);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  Get.put(CartController());
  Get.put(ContactController());
  Get.put(CounterController());
  Get.put(LoginController());

  await NotificationService().initialize(flutterLocalNotificationsPlugin);

  runApp(const BetterFeedback(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget defaultHome;
    final box = GetStorage();
    String? token = box.read('token');
    bool? verification = box.read("verificatio1n");
    /*return Scaffold(
      body: Container(
        child: Image.network("https://dbestech-code.oss-ap-southeast-1.aliyuncs.com/foodly_flutter/icons/fried%20rice.png?OSSAccessKeyId=LTAI5t8cUzUwGV1jf4n5JVfD&Expires=36001719651337&Signature=OLAAucrHwJmYVbU9FU1kLCjhCXE%3D"),
      ),
    );*/
    if (token == null) {
      // If no token, user is not logged in, so navigate to the login page
      defaultHome = const Login();
    } else if (token != null && verification == false) {
      // If user has a token but is not verified, go to VerificationPage
      defaultHome = const VerificationPage();
    } else if (token != null && verification == true) {
      // If user is logged in and verified, go to MainScreen
      defaultHome = MainScreen();
    } else {
      // If user is logged in and verified, go to MainScreen
      defaultHome = MainScreen();
    }
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 825),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Rivus Ordering App',
            theme: ThemeData(
              scaffoldBackgroundColor: Color(kOffWhite.value),
              iconTheme: IconThemeData(color: Color(kDark.value)),
              primarySwatch: Colors.grey,
            ),
            home: defaultHome,
            navigatorKey: navigatorKey,
            getPages: AppPages.routes,
            routes: {
              '/order_notification_details_page': (context) =>
                  const OrderNotificationDetailsPage(),
              '/order_details_page': (context) =>
                  OrderDetailsPage(orderId: Get.parameters['orderId']!),
              '/chat': (context) => const ChatPage(),
              // '/message': (context) => const MessagePage()
            },
          );
        }
      );
  }
}
