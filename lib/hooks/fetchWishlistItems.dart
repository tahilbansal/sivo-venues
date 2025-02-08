import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sivo_venues/models/environment.dart';
import 'package:sivo_venues/models/items.dart';
import 'package:sivo_venues/models/hook_models/hook_result.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchMyCatalog(supplierId) {
  final box = GetStorage();
  String token = box.read('token');
  String accessToken = jsonDecode(token);
  final items = useState<List<Item>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final url = Uri.parse(
        '${Environment.appBaseUrl}/api/wishlist/${supplierId != null ? '?supplierId=$supplierId' : ''}',
      );

      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        // final decodedBody = json.decode(response.body);
        // final List<dynamic> itemList = decodedBody['items'];
        final List<dynamic> itemList = json.decode(response.body)['items'];
        items.value =
            itemList.map((itemJson) => Item.fromJson(itemJson)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      error.value = e as Exception; // Handle error
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  // Return values
  return FetchHook(
    data: items.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
