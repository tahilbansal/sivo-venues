import 'package:flutter/material.dart';
import '../../item/widgets/item_categories_list.dart';

class FilterCategoriesModal extends StatelessWidget {
  const FilterCategoriesModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter by Category",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ItemCategoriesWidget(
              onCategorySelected: (String? selectedCategoryName) {
                Navigator.of(context).pop(selectedCategoryName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
