import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivus_user/common/shimmers/itemlist_shimmer.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/hooks/fetchOrders.dart';
import 'package:rivus_user/models/client_orders.dart';
import 'package:rivus_user/views/orders/widgets/client_order_tile.dart';

class PendingOrders extends HookWidget {
  const PendingOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchClientOrders('orderStatus', 'Placed');
    List<ClientOrders>? orders = hookResult.data;
    final isLoading = hookResult.isLoading;

    return Container(
      height: hieght / 1.3,
      width: width,
      color: kLightWhite,
      child: isLoading
          ? const ItemsListShimmer()
          : ListView.builder(
              padding: EdgeInsets.only(top: 10.h, left: 12.w, right: 12.w, bottom:5.w),
              itemCount: orders!.length,
              itemBuilder: (context, i) {
                ClientOrders order = orders[i];
                return ClientOrderTile(order: order);
              }
          ),
    );
  }
}
