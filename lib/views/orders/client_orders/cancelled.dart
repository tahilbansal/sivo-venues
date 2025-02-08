import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_venues/common/shimmers/itemlist_shimmer.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/hooks/fetchOrders.dart';
import 'package:sivo_venues/models/client_orders.dart';
import 'package:sivo_venues/views/orders/widgets/client_order_tile.dart';

class CancelledOrders extends HookWidget {
  const CancelledOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(CancelledController());
    final hookResult = useFetchClientOrders('orderStatus', 'Cancelled');
    List<ClientOrders>? orders = hookResult.data;
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

    // controller.setOnStatusChangeCallback(refetch);

    return Container(
      height: hieght / 1.3,
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
