import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:rivus_user/models/environment.dart';
import 'package:rivus_user/models/items.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ItemController extends GetxController {
  final box = GetStorage();
  final favorites = <String, bool>{}.obs;
  final RxDouble _totalPrice = 0.0.obs;
  final RxBool isLoading = false.obs;
  bool initialCheckedValue = false;
  List<String> ads = [];
  var currentPage = 0.obs;
  var wishlistItems = <Item>[].obs;

  void updatePage(int index) {
    currentPage.value = index;
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    // for (var additive in additivesList) {
    //   if (additive.isChecked.value) {
    //     totalPrice += double.tryParse(additive.price) ?? 0.0;
    //   }
    // }
    setAdditveTotal = totalPrice;
    return totalPrice;
  }

  List<String> getList() {
    List<String> ads = [];
    // for (var additive in additivesList) {
    //   if (additive.isChecked.value && !ads.contains(additive.title)) {
    //     ads.add(additive.title);
    //   }else if(!additive.isChecked.value && ads.contains(additive.title)){
    //     ads.remove(additive.title);
    //   }
    // }

    return ads;
  }

  double get additiveTotal => _totalPrice.value;

  // Setter to set the value
  set setAdditveTotal(double newValue) {
    _totalPrice.value = newValue;
  }

  // Method to check if an item is a favorite
  bool isFavorite(Item item) {
    return favorites[item.id] ?? false;
  }

  // Method to toggle favorite status for an item and sync with backend
  Future<void> toggleFavoriteStatus(Item item) async {
    if (isFavorite(item)) {
      await removeFromWishlist(item.id);
    } else {
      await addToWishlist(item);
    }
  }

  // Fetch wishlist items from the backend and initialize favorites
  Future<void> loadWishlist({String? supplierId}) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    String? userId = jsonDecode(box.read('userId'));
    final url = Uri.parse(
        '${Environment.appBaseUrl}/api/wishlist/${supplierId != null ? '?supplierId=$supplierId' : ''}');
    isLoading.value = true;
    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final List<dynamic> itemList = json.decode(response.body)['items'];
        wishlistItems.value =
            itemList.map((itemJson) => Item.fromJson(itemJson)).toList();
        for (var item in wishlistItems) {
          favorites[item.id] = true;
        }
      } else {
        print("Failed to load wishlist: ${response.body}");
      }
    } catch (error) {
      print("Error loading wishlist: $error");
    }
  }

  // Method to add item to wishlist via API
  Future<void> addToWishlist(Item item) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    String? userId = box.read('userId');

    final url = Uri.parse('${Environment.appBaseUrl}/api/wishlist/add');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({"itemId": item.id}),
      );

      if (response.statusCode == 200) {
        favorites[item.id] = true;
      } else {
        print("Failed to add item to wishlist: ${response.body}");
      }
    } catch (error) {
      print("Error adding to wishlist: $error");
    }
  }

  // Method to remove item from wishlist via API
  Future<void> removeFromWishlist(String itemId) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    String? userId = box.read("userId");

    final url = Uri.parse('${Environment.appBaseUrl}/api/wishlist/remove');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({"itemId": itemId}),
      );

      if (response.statusCode == 200) {
        favorites[itemId] = false;
      } else {
        print("Failed to remove item from wishlist: ${response.body}");
      }
    } catch (error) {
      print("Error removing from wishlist: $error");
    }
  }
}
