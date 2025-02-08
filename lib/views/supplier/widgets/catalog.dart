import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/common/shimmers/itemlist_shimmer.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/item_controller.dart';
import 'package:sivo_venues/hooks/fetchSupplierCatalog.dart';
import 'package:sivo_venues/models/items.dart';
import 'package:sivo_venues/views/item/widgets/item_tile.dart';
import 'package:sivo_venues/controllers/counter_controller.dart';

class SupplierCatalog extends HookWidget {
  const SupplierCatalog({
    super.key,
    required this.supplierId,
    this.heightFactor = 0.5,
  });

  final String supplierId;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchCatalog(supplierId);
    final items = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;

    // Initialize ItemController and load wishlist with supplierId
    final itemController = Get.put(ItemController());
    useEffect(() {
      itemController.loadWishlist(supplierId: supplierId);
      return null;
    }, []);

    return Scaffold(
      backgroundColor: kOffWhite,
      body: isLoading ?
      const ItemsListShimmer()
      : Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        height: hieght * heightFactor,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 80.0),
          itemCount: items?.length ?? 0,
          itemBuilder: (context, i) {
            Item item = items[i];
            return ItemTile(item: item);
          }
        ),
      ),
    );
  }
}
