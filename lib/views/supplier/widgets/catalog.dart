import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/common/shimmers/itemlist_shimmer.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/item_controller.dart';
import 'package:sivo_venues/hooks/fetchSupplierCatalog.dart';
import 'package:sivo_venues/models/items.dart';
import 'package:sivo_venues/views/item/widgets/item_tile.dart';

class SupplierCatalog extends HookWidget {
  const SupplierCatalog({
    super.key,
    required this.supplierId,
    this.heightFactor = 0.5,
    this.scrollToCategory,
  });

  final String supplierId;
  final double heightFactor;
  final ValueNotifier<String?>? scrollToCategory;

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchCatalog(supplierId);
    final items = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;
    final scrollController = useScrollController();
    final categoryKeys = useMemoized(() => <String, GlobalKey>{});


    // Initialize ItemController and load wishlist with supplierId
    final itemController = Get.put(ItemController());
    useEffect(() {
      itemController.loadWishlist(supplierId: supplierId);
      return null;
    }, []);

    // 🔸 Group items by category title
    final Map<String, List<Item>> groupedItems = {};
    for (var item in items) {
      final categoryTitle = item.categoryName ?? 'Uncategorized';
      groupedItems.putIfAbsent(categoryTitle, () => []).add(item);
    }

    // 🔹 Sort categories alphabetically
    final sortedEntries = groupedItems.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));


    // Create keys for each category for scrolling purposes
    for (var entry in groupedItems.entries) {
      categoryKeys.putIfAbsent(entry.key, () => GlobalKey());
    }

    // Scroll listener for category selection
    useEffect(() {
      final listener = () {
        final category = scrollToCategory?.value;
        if (category != null && categoryKeys.containsKey(category)) {
          final context = categoryKeys[category]!.currentContext;
          if (context != null) {
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      };

      scrollToCategory?.addListener(listener);
      return () => scrollToCategory?.removeListener(listener);
    }, [scrollToCategory]);


    return Scaffold(
      backgroundColor: kOffWhite,
      body: isLoading
          ? const ItemsListShimmer()
          : Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          height: height * heightFactor,
          child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.only(bottom: 80.0),
          children: sortedEntries.map((entry) {
            final category = entry.key;
            final categoryItems = entry.value;

            return Column(
              key: categoryKeys[category],
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Heading
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // List of Items in the Category
                ...categoryItems.map((item) => ItemTile(item: item)).toList(),
                const Divider(height: 30, thickness: 1),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
