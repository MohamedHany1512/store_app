/// Remote endpoints + network timeouts in one place.
abstract final class ApiEndpoints {
  const ApiEndpoints._();

  static const String baseUrl = 'https://dummyjson.com';
  static const String login = '/auth/login';
  static const String products = '/products';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);
}
