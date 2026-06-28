class AppConstants {
  static const String baseUrl = 'http://172.17.203.167:8080/v1';
  // static const String baseUrl = 'http://192.168.100.7:8080/v1';
  // static const String baseUrl = 'http://103.94.133.254:8080/v1';

  // Auth endpoints
  static const String verifyToken = '/auth/verify-token';
  static const String refreshToken = '/auth/refresh';

  // Product endpoints
  static const String products = '/products';

  // Cart endpoints
  static const String cart = '/cart';

  // Order endpoints
  static const String orders = '/orders';
  static const String checkout = '/orders/checkout';

  // Timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
