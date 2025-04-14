import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxString category = ''.obs;
  RxString supplierCategory = ''.obs;

  String get categoryValue => category.value;
  String get supplierCategoryValue => supplierCategory.value;

  set updateCategory(String newValue) {
    category.value = newValue;
  }
  set supplierUpdateCategory(String newValue) {
    supplierCategory.value = newValue;
  }

  RxString title = ''.obs;

  String get titleValue => title.value;

  set updateTitle(String newValue) {
    title.value = newValue;
  }
}
