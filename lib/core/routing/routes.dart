/// Central route table. No magic strings anywhere else in the app.
abstract final class Routes {
  const Routes._();

  static const String login = '/';
  static const String home = '/home';
  static const String productDetails = 'product/:productId';

  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String productDetailsName = 'product-details';

  /// Absolute path for a product deep link.
  static String productDetailsPath(int productId) =>
      '$home/product/$productId';

  /// Extracts the id from `/home/product/:productId`, or null when invalid.
  static int? parseProductId(String? pathParameter) {
    return int.tryParse(pathParameter ?? '');
  }
}
