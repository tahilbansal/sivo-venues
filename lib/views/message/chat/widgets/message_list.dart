import 'package:rivus_user/common/cached_image_loader.dart';
import 'package:rivus_user/common/entities/message.dart';
import 'package:rivus_user/common/show_snack_bar.dart';
import 'package:rivus_user/common/utils/date.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/controllers/counter_controller.dart';
import 'package:rivus_user/main.dart';
import 'package:rivus_user/views/message/chat/index.dart';
import 'package:rivus_user/views/message/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../common/values/colors.dart';

class MessageList extends GetView<MessageController> {
  const MessageList({Key? key}) : super(key: key);

  Widget messageListItem(Message item) {
    CounterController counterController = Get.put(CounterController());
    return Container(
      padding: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w),
      child: InkWell(
        onTap: () {
          Get.to(ChatPage(), arguments: {
            "doc_id": item.doc_id,
            "to_uid": item.token,
            "to_name": item.name,
            "to_avatar": item.avatar,
            "supplier_uid": item.supplier_uid
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 0.w, left: 0.w, right: 15.w),
              child: SizedBox(
                width: 54.w,
                height: 54.w,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: item.avatar!,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 54.w,
                        height: 54.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(54)),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                      errorWidget: (context, url, error) => const Image(
                          image: AssetImage('assets/images/feature-1.png')
                      ),
                    ),
                    if (counterController.hasSupplierItemCount(item.supplier_uid!)) // Check if cart icon is needed
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(
                          color: kPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 12.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 0.w, left: 0.w, right: 5.w),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180.w,
                    height: 48.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name!,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.bold,
                              color: AppColors.thirdElement,
                              fontSize: 16.sp),
                        ),
                        Text(
                          item.last_msg ?? "",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.normal,
                              color: AppColors.thirdElement,
                              fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60.w,
                    height: 54.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          duTimeLineFormat(
                              (item.last_time as Timestamp).toDate()),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.normal,
                              color: AppColors.thirdElementText,
                              fontSize: 12.sp),
                        ),
                        item.msg_num == 0
                            ? Container()
                            : Container(
                                padding: EdgeInsets.only(
                                    left: 4.w,
                                    right: 4.w,
                                    top: 0.h,
                                    bottom: 0.h),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text(
                                  "${item.msg_num}",
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.primaryElementText,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  var item = controller.state.filteredMsgList[index];
                  return messageListItem(item);
                }, childCount: controller.state.filteredMsgList.length),
              ),
            ),
          ],
        )
    );
  }
}
