import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/controllers/counter_controller.dart';
import '../../../constants/constants.dart';
import '../../../controllers/cart_controller.dart';
import '../cart_page.dart';

class CartBar extends StatelessWidget {
  final String supplierId;

  CartBar({required this.supplierId});
  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final CounterController counterController = Get.find<CounterController>();

    return Obx(() {
      int supplierCartItemCount = counterController.getSupplierItemCount(supplierId);

      if (supplierCartItemCount > 0) {
        return Container(
          color: kPrimary,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$supplierCartItemCount items in cart',
                style: const TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to CartPage
                  Get.to(() => CartPage(supplierId: supplierId));
                },
                child: const Text('View Cart'),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
