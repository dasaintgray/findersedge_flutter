import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:findersedge/services/constant/service_constant.dart';
import 'package:findersedge/services/exceptions/exception_service.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  static Future<dynamic> post(String baseURL, String endpoint, dynamic objPayload, dynamic httpHeaders) async {
    var uriEndpoint = Uri.parse(baseURL + endpoint);
    var payload = json.encode(objPayload);
    try {
      var response = await http
          .post(uriEndpoint, body: payload, headers: httpHeaders)
          .timeout(const Duration(seconds: ServiceConstant.receiveTimeOut));
      // var response = await dio
      //     .post(baseURL + endpoint, data: payload)
      //     .timeout(const Duration(seconds: HenryGlobal.receiveTimeOut));
      return processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uriEndpoint.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responding', uriEndpoint.toString());
    }
  }

  // GET
  static Future<dynamic> get(String baseURL, String endpoint, Map<String, String> httpHeaders) async {
    var uri = baseURL + endpoint;
    // var encoded = Uri.encodeFull(uri);
    // var uriEP = Uri.parse(baseURL + endpoint);
    // assert(encoded == uri);
    // var decoded = Uri.decodeFull(encoded);
    // assert(uri == decoded);

    var uriEP = Uri.parse(uri);

    try {
      var response =
          await http.get(uriEP, headers: httpHeaders).timeout(const Duration(seconds: ServiceConstant.receiveTimeOut));
      return processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uriEP.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responding', uriEP.toString());
    }
  }

  Future<dynamic> getOLD(String baseURL, String endpoint, Map<String, String> httpHeaders, {dynamic queryParam}) async {
    // var uri = Uri.https(baseURL, endpoint);
    var uri = Uri.parse(baseURL + endpoint);

    var response =
        await http.get(uri, headers: httpHeaders).timeout(const Duration(seconds: ServiceConstant.connectionTimeOut));
    // var response = await http.get(url);
    return processResponse(response);
  }

  // GLOBAL PROCESS RESPONSE
  static dynamic processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200: // READ RESPONSE
        var responseJSON = utf8.decode(response.bodyBytes);
        return responseJSON;
      case 201: //CREATE, UPDATE
        var responseJSON = utf8.decode(response.bodyBytes);
        return responseJSON;
      case 400:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 422:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException('Error occured with code : ${response.statusCode}', response.request!.url.toString());
    }
  }
}
