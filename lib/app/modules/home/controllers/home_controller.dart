// ignore_for_file: unnecessary_overrides

import 'package:findersedge/app/data/models/products_model.dart';
import 'package:findersedge/services/providers/service_provider.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // LIST
  final productList = <ProductsModel>[];
  final wishList = <ProductsModel>[];
  final shoppingCart = <Product>[];
  final searchList = <Product>[].obs;

  // boolean
  final isLoading = true.obs;
  final isSearchEnabled = false.obs;
  final isSorted = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //================================================================

  Future<bool?> fetchProducts() async {
    final response = await ServiceProvider.getProducts();
    if (response!.products.isNotEmpty) {
      isLoading.value = false;
      // productList.add(response);
      searchList.addAll(response.products);
      return true;
    }
    return false;
  }

  Future<bool?> searchProducts(String item) async {
    final response = await ServiceProvider.searchProducts(item);
    if (response!.products.isNotEmpty) {
      searchList.clear();
      searchList.addAll(response.products);
      return true;
    }
    return false;
  }

  Future<bool?> sortProdcuts(String sortMode, String order) async {
    final result = await ServiceProvider.sortProducts(sortMode: sortMode, order: order);
    if (result!.products.isNotEmpty) {
      searchList.clear();
      searchList.addAll(result.products);
      return true;
    }
    return false;
  }

  bool searchItems(String items) {
    final response = productList.first.products.where((element) => element.title.contains(items)).toList();

    if (response.isNotEmpty) {
      searchList.clear();
      searchList.addAll(response);
      // searchList.refresh();
      return true;
    }
    return false;
  }
}
