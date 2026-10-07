 
abstract final class AppStrings {
  const AppStrings._();

  static const String appTitle = 'Store App';

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------
  static const String welcomeBack = 'Welcome back';
  static const String loginSubtitle = 'Sign in to continue shopping';
  static const String username = 'Username';
  static const String usernameHint = 'emily.johnson';
  static const String password = 'Password';
  static const String passwordHint = '••••••••';
  static const String forgotPassword = 'Forgot password?';
  static const String forgotPasswordHint =
      'Password reset is not available in this demo yet.';
  static const String login = 'Log in';
  static const String loggingIn = 'Logging in…';
  static const String noAccount = "Don't have an account?";
  static const String createAccount = 'Create one';
  static const String usernameRequired = 'Please enter your username';
  static const String usernameTooShort = 'Username must be at least 3 characters';
  static const String passwordRequired = 'Please enter your password';
  static const String passwordTooShort = 'Password must be at least 6 characters';

  // ---------------------------------------------------------------------------
  // Home
  // ---------------------------------------------------------------------------
  static const String greetingMorning = 'Good morning';
  static const String greetingAfternoon = 'Good afternoon';
  static const String greetingEvening = 'Good evening';
  static const String searchHint = 'Search products';
  static const String allCategories = 'All';
  static const String productsCount = 'products';
  static const String noProductsTitle = 'No products found';
  static const String noProductsMessage =
      'Try a different search term or category.';
  static const String somethingWrongTitle = 'Something went wrong';
  static const String retry = 'Retry';
  static const String favorites = 'Favorites';
  static const String addToFavorites = 'Add to favorites';
  static const String details = 'Details';
  static const String quantity = 'Quantity';
  static const String addToCart = 'Add to cart';
  static const String addedToCart = 'Added to cart';
  static const String outOfStock = 'Out of stock';
  static const String rating = 'Rating';
  static const String logout = 'Log out';
  static const String readMore = 'Read more';
  static const String readLess = 'Read less';

  // ---------------------------------------------------------------------------
  // Generic / errors
  // ---------------------------------------------------------------------------
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError =
      'No internet connection. Check your network and retry.';
  static const String serverError = 'The server is unavailable right now.';
  static const String invalidCredentials =
      'Invalid username or password. Please try again.';
  static const String sessionExpired = 'Your session expired. Please log in again.';
  static const String pageNotFound = 'This page does not exist.';
  static const String goBackHome = 'Back to store';
  static const String genericImageError = 'Image unavailable';
}
