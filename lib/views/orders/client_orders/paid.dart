import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_venues/common/entities/message.dart';
import 'package:sivo_venues/common/shimmers/itemlist_shimmer.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/contact_controller.dart';
//import 'package:sivo_venues/controllers/updates_controllers/preparing_controller.dart';
import 'package:sivo_venues/hooks/fetchOrders.dart';
import 'package:sivo_venues/models/client_orders.dart';
import 'package:sivo_venues/views/message/controller.dart';
import 'package:sivo_venues/views/orders/widgets/client_order_tile.dart';
import 'package:get/get.dart';

class PaidOrders extends HookWidget {
  const PaidOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final controller = Get.put(PreparingController());
    final hookResult = useFetchClientOrders('paymentStatus', 'Completed');
    List<ClientOrders>? orders = hookResult.data;
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

    //controller.setOnStatusChangeCallback(refetch);
    final msgController = Get.put(MessageController());
    Get.put(ContactController());
    return Container(
      height: height / 1.3,
      width: width,
      color: kLightWhite,
      child: isLoading
          ? const ItemsListShimmer()
          : ListView.builder(
              padding: EdgeInsets.only(top: 10.h, left: 12.w, right: 12.w),
              itemCount: orders!.length,
              itemBuilder: (context, i) {
                ClientOrders order = orders[i];

                return ClientOrderTile(order: order);
              }),
    );
  }
}
