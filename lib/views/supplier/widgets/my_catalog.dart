import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sivo_venues/common/shimmers/itemlist_shimmer.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/hooks/fetchWishlistItems.dart';
import 'package:sivo_venues/models/items.dart';
import 'package:sivo_venues/views/item/widgets/item_tile.dart';

class MyCatalog extends HookWidget {
  const MyCatalog({super.key, required this.supplierId});

  final String supplierId;

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchMyCatalog(supplierId);
    final items = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;

    return Scaffold(
      backgroundColor: kOffWhite,
      body: isLoading
          ? const ItemsListShimmer()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              height: height * 0.5,
              child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  itemCount: items?.length ?? 0,
                  itemBuilder: (context, i) {
                    Item item = items[i];
                    return ItemTile(item: item);
                  }),
            ),
    );
  }
}
