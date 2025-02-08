import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sivo_venues/controllers/cart_controller.dart';
import 'package:sivo_venues/models/cart_request.dart';
import 'package:sivo_venues/models/items.dart';
import 'package:sivo_venues/models/user_cart.dart';

class CounterController extends GetxController {
  final box = GetStorage();
  final CartController cartController = Get.put(CartController());
  final RxMap<String, RxMap<String, RxInt>> supplierItemCounts = <String, RxMap<String, RxInt>>{}.obs;
  final RxDouble rxCartTotal = 0.0.obs;
  final RxList<UserCart> rxUserCarts = <UserCart>[].obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    Map<String, dynamic> storedCounts = box.read('supplierItemCounts') ?? {};
    supplierItemCounts.assignAll(storedCounts.map((supplierId, items) {
      RxMap<String, RxInt> rxItemMap = RxMap<String, RxInt>();
      (items as Map).forEach((itemId, count) {
        rxItemMap[itemId] = RxInt(count);
      });
      return MapEntry(supplierId, rxItemMap);
    }));
  }

  void increment(Item item) async{
    String supplierId = item.supplier;
    String itemId = item.id;
    supplierItemCounts[supplierId] ??= <String, RxInt>{}.obs;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      supplierItemCounts[supplierId]![itemId] ??= RxInt(0);
      supplierItemCounts[supplierId]![itemId]!.value++;
      rxCartTotal.value += item.price ?? 0.0;
      _saveItemCountsAndTotalToLocalStorage();
      await updateCart(item);
    });
  }

  void decrement(Item item) async {
    String supplierId = item.supplier;
    String itemId = item.id;
    if (supplierItemCounts[supplierId] != null &&
        supplierItemCounts[supplierId]![itemId] != null &&
        supplierItemCounts[supplierId]![itemId]!.value > 0) {

      if (_debounce?.isActive ?? false) _debounce?.cancel();

      _debounce = Timer(const Duration(milliseconds: 200), () async {
        supplierItemCounts[supplierId]![itemId]!.value--;

        if (supplierItemCounts[supplierId]![itemId]!.value >= 0) {
          rxCartTotal.value -= item.price ?? 0.0;
          await cartController.decrementFromCart(item.id);
        }
        _saveItemCountsAndTotalToLocalStorage();
      });
      }
  }

  Future<void> updateCart(Item item) async {
    String supplierId = item.supplier;
    String itemId = item.id;
    int count = supplierItemCounts[supplierId]?[itemId]?.value ?? 0;

    ToCart cartItem = ToCart(
      productId: itemId,
      supplierId: supplierId,
      instructions: "",
      additives: [],
      quantity: count,
      totalPrice: 0,
    );
    await cartController.addToCart(toCartToJson(cartItem));
  }

  void _saveItemCountsAndTotalToLocalStorage() {
    Map<String, Map<String, int>> simpleMap =
        supplierItemCounts.map((supplierId, items) {
      return MapEntry(supplierId, items.map((itemId, count) => MapEntry(itemId, count.value)));
    });
    box.write('supplierItemCounts', simpleMap);
    box.write('cartTotal', rxCartTotal.value);
  }

  int getItemCount(String supplierId, String itemId) {
    return supplierItemCounts[supplierId]?[itemId]?.value ?? 0;
  }

  int getSupplierItemCount(String supplierId) {
    if (supplierItemCounts.containsKey(supplierId)) {
      return supplierItemCounts[supplierId]!.values.fold(0, (sum, count) => sum + count.value);
    }
    return 0;
  }

  bool hasSupplierItemCount(String supplierId) {
    if (supplierItemCounts.containsKey(supplierId)) {
      return supplierItemCounts[supplierId]!.values.fold(0, (sum, count) => sum + count.value) > 0;
    }
    return false;
  }

  void resetItemCount(String supplierId, String itemId) {
    supplierItemCounts[supplierId]?[itemId]?.value = 0;
  }

  void calculateInitialCartTotal(List<UserCart> userCarts) {
    double total = 0;
    for (var userCart in userCarts) {
      total += userCart.grandTotal;
    }
    rxCartTotal.value = total;
  }

  void updateCartTotal(double amount) {
    rxCartTotal.value += amount;
  }

}
