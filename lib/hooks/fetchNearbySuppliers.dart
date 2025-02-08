// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sivo_venues/models/api_error.dart';
import 'package:sivo_venues/models/environment.dart';
import 'package:sivo_venues/models/hook_models/hook_result.dart';
import 'package:sivo_venues/models/suppliers.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchSuppliers() {
  final suppliers = useState<List<Suppliers>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

// Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      //var url = Uri.parse('${Environment.appBaseUrl}/api/supplier/41007428');
      var url = Uri.parse('${Environment.appBaseUrl}/api/supplier/FG123');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        suppliers.value = suppliersFromJson(response.body);
        isLoading.value = false;
      } else {
        var error = apiErrorFromJson(response.body);
        isLoading.value = false;
      }
    } catch (e) {
      debugPrint(e.toString());
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
    data: suppliers.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
