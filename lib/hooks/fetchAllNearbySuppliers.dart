import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/models/environment.dart';
import 'package:sivo_venues/models/hook_models/hook_result.dart';
import 'package:sivo_venues/models/suppliers.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchAllSuppliers() {
  final suppliers = useState<List<Suppliers>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final response = await http
          .get(Uri.parse('${Environment.appBaseUrl}/api/supplier/all'));

      if (response.statusCode == 200) {
        suppliers.value = suppliersFromJson(response.body);
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
    data: suppliers.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
