import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rivus_user/controllers/contact_controller.dart';
import 'package:rivus_user/models/environment.dart';
import 'package:rivus_user/models/hook_models/hook_result.dart';
import 'package:rivus_user/models/suppliers.dart';
import 'package:rivus_user/models/user_cart.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

// Custom Hook
FetchHook useFetchSupplier(id) {
  final supplier = useState<Suppliers?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final controller = Get.find<ContactController>();
  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final response = await http
          .get(Uri.parse('${Environment.appBaseUrl}/api/supplier/byId/$id'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        Suppliers fetchedSupplier = Suppliers.fromJson(data);
        supplier.value = fetchedSupplier;
        controller.state.supplier.value = fetchedSupplier;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e.toString());
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
    data: supplier.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
