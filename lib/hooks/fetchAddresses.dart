import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sivo_venues/models/all_addresses.dart';
import 'package:sivo_venues/models/environment.dart';
import 'package:sivo_venues/models/hook_models/hook_result.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchAdresses() {
  final box = GetStorage();
  final addressesList = useState<List<AddressesList>>([]);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${Environment.appBaseUrl}/api/address/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        addressesList.value = addressesListFromJson(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      error.value = e as Exception?;
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
    data: addressesList.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
