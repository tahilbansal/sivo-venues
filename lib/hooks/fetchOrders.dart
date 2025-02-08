import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/models/api_error.dart';
import 'package:sivo_venues/models/client_orders.dart';
import 'package:sivo_venues/models/environment.dart';
import 'package:sivo_venues/models/hook_models/hook_result.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchClientOrders(String query, String paymentStatus) {
  final box = GetStorage();
  final orders = useState<List<ClientOrders>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  final isMounted = useIsMounted();

  // Fetch Data Function
  Future<void> fetchData() async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    if (!isMounted()) return;

    isLoading.value = true;
    try {
      Uri url = Uri.parse('${Environment.appBaseUrl}/api/orders?$query=$paymentStatus');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        if (isMounted()) {
          orders.value = clientOrdersFromJson(response.body);
        }
      } else {
        var error = apiErrorFromJson(response.body);
        if (isMounted()) {
          Get.snackbar(error.message, "Failed to get data, please try again",
              colorText: kLightWhite,
              backgroundColor: kRed,
              icon: const Icon(Icons.error));
        }
      }
    } catch (e) {
      if (isMounted()) {
        Get.snackbar(e.toString(), "Failed to get data, please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
        error.value = e as Exception?;
      }
    } finally {
      if (isMounted()) {
        isLoading.value = false;
      }
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    if (isMounted()) {
      isLoading.value = true;
      fetchData();
    }
  }

  // Return values
  return FetchHook(
    data: orders.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
