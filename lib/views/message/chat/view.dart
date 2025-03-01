import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/common/values/colors.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/counter_controller.dart';
import 'package:sivo_venues/controllers/login_controller.dart';
import 'package:sivo_venues/views/cart/cart_page.dart';
import 'package:sivo_venues/views/message/chat/widgets/chat_bar.dart';
import 'package:sivo_venues/views/message/chat/widgets/chat_list.dart';
import 'package:sivo_venues/views/supplier/supplier_catalog_page.dart';

import '../../entrypoint.dart';
import '../../supplier/suppliers_page.dart';
import 'controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: kPrimary,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      title: Container(
        padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
              child: InkWell(
                onTap: () async {
                  if (controller.supplier.value != null) {
                    Get.to(() =>
                        SupplierPage(supplier: controller.supplier.value!));
                  }
                },
                child: SizedBox(
                  width: 44.w.clamp(44,52),
                  height: 44.w.clamp(44,52),
                  child: CachedNetworkImage(
                    imageUrl: controller.state.to_avatar.value,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 44.w.clamp(44,52),
                      width: 44.w.clamp(44,52),
                      margin: null,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(44.w.clamp(44,52))),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    errorWidget: (context, url, error) => const Image(
                      image: AssetImage('assets/images/profile-photo.png'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15.w.clamp(15,19),
            ),
            Container(
              width: 180.w.clamp(180,240),
              padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 180.w.clamp(180,240),
                    height: 44.w.clamp(44,52),
                    child: GestureDetector(
                      onTap: () {
                        if (controller.supplier.value != null) {
                          Get.to(() => SupplierPage(
                              supplier: controller.supplier.value!));
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.state.to_name.value,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBackground,
                                fontSize: 16.sp.clamp(16,20)),
                          ),
                          Obx(() => Text(
                                controller.state.to_location.value,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.primaryBackground,
                                    fontSize: 14.sp.clamp(14,20)),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Get.offAll(() => MainScreen(), arguments: 1);
        },
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("Gallery"),
                  onTap: () {
                    controller.imgFromGallery();
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text("Camera"),
                  onTap: () {
                    controller.imgFromCamera();
                    Get.back();
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => LoginController());
    CounterController counterController = Get.put(CounterController());

    // return WillPopScope(
    //   onWillPop: () async {
    //     //Get.off(() => MainScreen(), arguments: 1);
    //     return false; // Prevents the default back navigation
    //   },
    return Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Stack(
              children: [
                const ChatList(),
                // Start Order Bar
                Positioned(
                  bottom: 52.h,
                  left: 0.w,
                  right: 0.w,
                  child: Obx(() {
                    return ChatBar(
                      hasItemsInCart: counterController
                          .hasSupplierItemCount(controller.state.supplier_uid),
                      onStartOrder: () {
                        if (controller.supplier.value != null) {
                          Get.to(() =>
                              SupplierPage(supplier: controller.supplier.value!));
                        }
                      },
                      onGoToCart: () {
                        Get.to(() => CartPage(supplierId: controller.state.supplier_uid));
                      },
                    );
                  }),
                ),
                // Send Messages Container
                Positioned(
                  bottom: 0.h,
                  height: 50.h,
                  left: 0.h,
                  right: 0.h,
                  child: Container(
                    height: 50.h,
                    color: AppColors.primaryBackground,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: SizedBox(
                            width: 217.w,
                            height: 50.h,
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              controller: controller.textController,
                              autofocus: false,
                              focusNode: controller.contentNode,
                              decoration: const InputDecoration(
                                  hintText: "Send messages..."),
                            ),
                          ),
                        ),
                        Container(
                          height: 30.h.clamp(30, 40),
                          width: 30.w.clamp(30, 40),
                          margin: EdgeInsets.only(left: 5.w),
                          child: GestureDetector(
                            child: Icon(
                              Icons.photo_outlined,
                              size: 35.w.clamp(35, 45),
                              color: Colors.blue,
                            ),
                            onTap: () {
                              _showPicker(context);
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w, top: 5.h),
                          width: 85.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: kPrimary,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 1.0,
                                    spreadRadius: 2.0,
                                    offset: const Offset(0, 1),
                                    color: kPrimary.withOpacity(0.5))
                              ]),
                          child: GestureDetector(
                              child: const Center(
                                  child: Text(
                                "Send",
                                style: TextStyle(color: kOffWhite),
                              )),
                              onTap: () {
                                controller.sendMessage();
                              }),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
        //),
        );
  }
}
