import 'dart:convert';

import 'package:sivo_venues/models/environment.dart';
import 'package:sivo_venues/models/items.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/suppliers.dart';

class ItemSearchController extends GetxController {
  final _searchQuery = 'initial value'.obs;

  String get searchQuery => _searchQuery.value;

  set setSearchQuery(String newValue) {
    _searchQuery.value = newValue;
  }

  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  List<Item>? itemsResults;
  List<Suppliers>? suppliersResults;

  void searchItems(String key) async {
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/items/search/$key');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setLoading = false;
        // Parse the results for items and suppliers separately
        var data = jsonDecode(response.body);
        itemsResults = itemFromJson(jsonEncode(data['items']));
        suppliersResults = suppliersFromJson(jsonEncode(data['suppliers']));
        update();

        return;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setLoading = false;
      rethrow;
    } finally {
      setLoading = false;
    }
  }
  void searchCatalogItems(String supplierId,String key) async {
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/items/search-catalog/$key?supplierId=$supplierId');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setLoading = false;
        var data = jsonDecode(response.body);
        itemsResults = itemFromJson(jsonEncode(data['items']));
        update();
        return;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setLoading = false;
      rethrow;
    } finally {
      setLoading = false;
    }
  }
}
