class ServiceConstant {
  static const Map<String, String> httpHeader = {
    'content-type': 'application/json',
  };

  // timeout
  static const int receiveTimeOut = 20;
  static const int connectionTimeOut = 25;

  // endpoint
  static const String baseURL = 'https://dummyjson.com';
  static const String productEndpoint = '/products';
  

  // endpoint params - for paging
  static const int limit = 194; //get total value, default 30 if the data is large
  static const int skip = 0; //change if the data is very large
}
