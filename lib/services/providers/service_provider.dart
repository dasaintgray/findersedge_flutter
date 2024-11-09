import 'package:findersedge/app/data/models/products_model.dart';
import 'package:findersedge/services/base/network_service.dart';
import 'package:findersedge/services/constant/service_constant.dart';
import 'package:findersedge/services/errorHandler/service_error_handler.dart';

class ServiceProvider extends ServiceErrorHandler {
  static Future<ProductsModel?> getProducts() async {
    final response = await NetworkService.get(
      ServiceConstant.baseURL,
      '${ServiceConstant.productEndpoint}?limit=194',
      ServiceConstant.httpHeader,
    );
    if (response != null) {
      return productsModelFromJson(response);
    }
    return null;
  }

  static Future<ProductsModel?> searchProducts(String item) async {
    final response = await NetworkService.get(
        ServiceConstant.baseURL, '${ServiceConstant.productEndpoint}/search?q=$item', ServiceConstant.httpHeader);
    if (response != null) {
      return productsModelFromJson(response);
    }
    return null;
  }

  static Future<ProductsModel?> sortProducts({String sortMode = 'title', String order = 'asc'}) async {
    String params = '?sortBy=$sortMode&order=$order';
    final response = await NetworkService.get(
        ServiceConstant.baseURL, '${ServiceConstant.productEndpoint}$params', ServiceConstant.httpHeader);
    if (response != null) {
      return productsModelFromJson(response);
    }
    return null;
  }
}
