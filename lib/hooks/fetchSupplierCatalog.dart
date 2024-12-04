import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rivus_user/models/environment.dart';
import 'package:rivus_user/models/items.dart';
import 'package:rivus_user/models/hook_models/hook_result.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchCatalog(id) {
  final items = useState<List<Item>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('${Environment.appBaseUrl}/api/items/supplier-items/$id'));

      if (response.statusCode == 200) {
        items.value = itemFromJson(response.body);
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
    data: items.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
