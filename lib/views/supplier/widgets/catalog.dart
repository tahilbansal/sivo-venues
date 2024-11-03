import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:rivus_user/common/shimmers/itemlist_shimmer.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/controllers/item_controller.dart';
import 'package:rivus_user/hooks/fetchSupplierCatalog.dart';
import 'package:rivus_user/models/items.dart';
import 'package:rivus_user/views/item/widgets/item_tile.dart';
import 'package:rivus_user/controllers/counter_controller.dart';

class SupplierCatalog extends HookWidget {
  const SupplierCatalog({
    super.key,
    required this.supplierId,
  });

  final String supplierId;

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
      backgroundColor: kLightWhite,
      body: isLoading
          ? const ItemsListShimmer()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              height: hieght * 0.5,
              child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  itemCount: items?.length ?? 0,
                  itemBuilder: (context, i) {
                    Item item = items[i];
                    return ItemTile(item: item);
                  }),
            ),
    );
  }
}
