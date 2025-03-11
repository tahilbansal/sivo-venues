import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:sivo_venues/common/entities/message.dart';
import 'package:sivo_venues/common/utils/date.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/counter_controller.dart';
import 'package:sivo_venues/views/message/chat/index.dart';
import 'package:sivo_venues/views/message/controller.dart';
import '../../../../common/values/colors.dart';

class MessageList extends GetView<MessageController> {
  const MessageList({Key? key}) : super(key: key);

  Widget messageListItem(Message item) {
    CounterController counterController = Get.find<CounterController>();

    return InkWell(
      onTap: () {
        Get.to(ChatPage(), arguments: {
          "doc_id": item.doc_id,
          "to_uid": item.token,
          "to_name": item.name,
          "to_avatar": item.avatar,
          "supplier_uid": item.supplier_uid
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Avatar with Cart Icon**
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(27.r),
                  child: CachedNetworkImage(
                    imageUrl: item.avatar ?? '',
                    width: 54.w.clamp(54, 62),
                    height: 54.w.clamp(54, 62),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/sivo_logo.png', width: 54.w.clamp(54, 62), height: 54.w.clamp(54, 62)),
                  ),
                ),
                if (counterController.hasSupplierItemCount(item.supplier_uid ?? ""))
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 18.w.clamp(18, 24),
                      height: 18.w.clamp(18, 24),
                      decoration: BoxDecoration(
                        color: kPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Icon(Icons.shopping_cart, color: Colors.white, size: 12.w.clamp(12, 16)),
                    ),
                  ),
              ],
            ),

            SizedBox(width: 12.w),

            /// **Message Details**
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// **User Name**
                  Text(
                    item.name ?? "Unknown",
                    style: TextStyle(
                      fontSize: 16.sp.clamp(16, 20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.thirdElement,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),

                  /// **Last Message**
                  Text(
                    item.last_msg ?? "No messages yet",
                    style: TextStyle(
                      fontSize: 14.sp.clamp(14, 18),
                      color: AppColors.thirdElement,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            /// **Timestamp & Unread Message Count**
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// **Time**
                Text(
                  duTimeLineFormat((item.last_time as Timestamp).toDate()),
                  style: TextStyle(
                    fontSize: 12.sp.clamp(12, 16),
                    color: AppColors.thirdElementText,
                  ),
                ),

                SizedBox(height: 4.h),

                /// **Unread Messages Badge**
                if (item.msg_num! > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      "${item.msg_num}",
                      style: TextStyle(
                        fontSize: 11.sp.clamp(11, 15),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
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
                  var item = controller.state.msgList[index];
                  return messageListItem(item);
                }, childCount: controller.state.msgList.length),
              ),
            ),
          ],
        )
    );
  }
}
