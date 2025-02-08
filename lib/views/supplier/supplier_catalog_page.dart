import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/counter_controller.dart';
import 'package:sivo_venues/views/cart/widgets/cart_bar.dart';
import 'package:sivo_venues/views/supplier/widgets/catalog.dart';
import 'package:sivo_venues/views/supplier/widgets/my_catalog.dart';

class SupplierCatalogPage extends StatelessWidget {
  final String supplierId;

  const SupplierCatalogPage({super.key, required this.supplierId});

  @override
  Widget build(BuildContext context) {
    final CounterController counterController = Get.put(CounterController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalogs"),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              indicator: BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.circular(25),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Supplier Catalog"),
                Tab(text: "My Catalog"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SupplierCatalog(supplierId: supplierId, heightFactor: 0.8),
                  MyCatalog(supplierId: supplierId),
                ],
              ),
            ),
            Positioned(
              bottom: 0, // Positioned at the bottom of the screen
              left: 0,
              right: 0,
              child: Obx(() {
                // Only show the CartBar if items are in the cart
                return counterController.hasSupplierItemCount(supplierId)
                    ? CartBar(supplierId: supplierId)
                    : const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
