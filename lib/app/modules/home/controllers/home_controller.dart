// ignore_for_file: unnecessary_overrides

import 'package:findersedge/app/data/models/products_model.dart';
import 'package:findersedge/services/providers/service_provider.dart';
import 'package:flutter/material.dart';
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
  final isItemFound = true.obs;

  final productMap = {}.obs;
  final qtyMonitoring = 0.obs;
  final productActive = ''.obs;
  final currency = ''.obs;

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

  //
  get productPrice => productMap.entries.map((e) => e.key.price * e.value).toList();

  get totalCart => productMap.entries
      .map((e) => e.key.price * e.value)
      .toList()
      .reduce((value, element) => value + element)
      .toStringAsFixed(2);

  get totalQty => productMap.entries.map((e) => e.value).toList().reduce((value, element) => value + element);

  // cart
  void addProductToCart(ProductsModel productModel) {
    if (productMap.containsKey(productModel)) {
      productMap[productModel] += 1;
    } else {
      productMap[productModel] = 1;
    }
    // currency.value = productModel.products.first.price as String;
    qtyMonitoring.value = productMap[productModel] ?? 0;
  }

  void removeProductFromCart(ProductsModel productModel) {
    if (productMap.containsKey(productModel) && productMap[productModel] == 1) {
      productActive.value = productModel.products.first.title;
      productMap.removeWhere((key, value) => key == productModel);
    } else {
      productActive.value = productModel.products.first.title;
      productMap[productModel] -= 1;
    }
    qtyMonitoring.value = productMap[productModel] ?? 0;
    // print(qtyMonitoring);
    if (qtyMonitoring.value == 0) {
      Get.defaultDialog(
        middleText: "Do you want to remove this product? \n$productActive",
        textCancel: "No",
        textConfirm: "Yes",
        barrierDismissible: false,
        onCancel: () {
          productMap[productModel] = 1;
        },
        onConfirm: () {
          Get.back();
        },
      );
    }
  }

  void removeOneProduct(ProductsModel productsModel) {
    productMap.removeWhere((key, value) => key == productsModel);
  }

  void clearALL() {
    Get.defaultDialog(
      title: "  Do you want to clear All?   ",
      titleStyle: const TextStyle(
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      middleText: 'Are you sure?',
      middleTextStyle: const TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.black.withOpacity(0.5),
      // radius: 10,
      textCancel: " No ",
      cancelTextColor: Colors.white,
      textConfirm: " Yes ",
      confirmTextColor: Colors.white,
      onCancel: () {
        // to CartScreen
      },
      onConfirm: () {
        productMap.clear();
        Get.back();
      },
      buttonColor: Colors.orange,
    );
  }

  //================================================================
  Future<bool?> fetchProducts() async {
    final response = await ServiceProvider.getProducts();
    if (response!.products.isNotEmpty) {
      isLoading.value = false;
      // productList.add(response);
      searchList.addAll(response.products);
      isItemFound.value = true;
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
