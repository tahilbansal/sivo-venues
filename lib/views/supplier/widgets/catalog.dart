import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/common/shimmers/itemlist_shimmer.dart';
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

    // Create a dedicated scroll controller for the catalog section
    final scrollController = useScrollController();

    final categoryKeysRef = useRef<Map<String, GlobalKey>>({});
    final categoryKeys = categoryKeysRef.value;

    final isMounted = useIsMounted();

    // Track if initial scroll has been attempted
    final hasScrolledRef = useRef<bool>(false);

    // Initialize ItemController and load wishlist with supplierId
    final itemController = Get.put(ItemController());

    useEffect(() {
      itemController.loadWishlist(supplierId: supplierId);
      return null;
    }, [supplierId]);

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

    void scrollToSelectedCategory() {
      final category = scrollToCategory?.value;
      if (category != null && categoryKeys.containsKey(category)) {
        // Reset the flag when a new category is selected
        hasScrolledRef.value = false;

        // Use a delayed callback to ensure the UI has been built
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!isMounted()) return;

          final context = categoryKeys[category]?.currentContext;
          if (context == null) {
            debugPrint("Scroll target context is null for category: $category");

            // If context is null, try again after a longer delay
            if (!hasScrolledRef.value) {
              hasScrolledRef.value = true;
              Future.delayed(const Duration(milliseconds: 500), () {
                scrollToSelectedCategory();
              });
            }
            return;
          }

          // Calculate the position of the category in the scrollable area
          final RenderBox box = context.findRenderObject() as RenderBox;
          final position = box.localToGlobal(Offset.zero);
          final scrollPosition = position.dy;

          // Get the RenderBox of the scrollable container
          final RenderBox scrollBox = context.findAncestorRenderObjectOfType<RenderBox>()!;
          final scrollableSize = scrollBox.size.height;

          // Calculate the scroll offset to position the category heading at the top
          final scrollOffset = scrollController.offset + (position.dy - 320);

          // Ensure we don't scroll beyond content bounds
          scrollController.animateTo(
            scrollOffset.clamp(0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
    }

    useEffect(() {
      // Listen for changes to the selected category
      scrollToCategory?.addListener(scrollToSelectedCategory);

      // Initial scroll attempt if a category is already selected
      if (scrollToCategory?.value != null && !hasScrolledRef.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToSelectedCategory();
        });
      }

      return () => scrollToCategory?.removeListener(scrollToSelectedCategory);
    }, [scrollToCategory]);

    return isLoading
        ? const ItemsListShimmer()
        : Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      height: MediaQuery.of(context).size.height * heightFactor,
      // Use a SingleChildScrollView with a Column to ensure proper scrolling
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(), // Prevents overscroll
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
