import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sivo_venues/models/api_error.dart';
import 'package:sivo_venues/models/environment.dart';
import 'package:sivo_venues/models/hook_models/hook_result.dart';
import 'package:sivo_venues/models/user_cart.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchCart({String? supplierId}) {
  final box = GetStorage();
  final cartData = useState<List<UserCart>?>([]);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  String? token = box.read('token');
  String accessToken = "";

  if (token != null) {
    accessToken = jsonDecode(token);
  }

  // Fetch Data Function
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${Environment.appBaseUrl}/api/cart${supplierId != null ? '?supplierId=$supplierId' : ''}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        cartData.value = userCartFromJson(response.body);
        isLoading.value = false;
      } else {
        var error = apiErrorFromJson(response.body);
        isLoading.value = false;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect
  useEffect(() {
    if (token != null) {
      fetchData();
    }
    return null;
  }, const[]);

  // Refetch Function
  void refetch() {
    isLoading.value = true;
    fetchData();
  }


  // Return values
  return FetchHook(
    data: cartData.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
