part of 'products_cubit.dart';

enum ProductsStatus { initial, loading, success, failure }

/// Immutable state of the catalog screen.
final class ProductsState extends Equatable {
  const ProductsState({
    required this.status,
    this.products = const <Product>[],
    this.categories = const <String>[],
    this.query = '',
    this.selectedCategory,
    this.favoriteIds = const <int>{},
    this.isRefreshing = false,
    this.message,
  });

  const ProductsState.initial()
      : status = ProductsStatus.initial,
        products = const <Product>[],
        categories = const <String>[],
        query = '',
        selectedCategory = null,
        favoriteIds = const <int>{},
        isRefreshing = false,
        message = null;

  const ProductsState.loading()
      : status = ProductsStatus.loading,
        products = const <Product>[],
        categories = const <String>[],
        query = '',
        selectedCategory = null,
        favoriteIds = const <int>{},
        isRefreshing = false,
        message = null;

  const ProductsState.failure({
    required this.message,
    this.products = const <Product>[],
  })  : status = ProductsStatus.failure,
        categories = const <String>[],
        query = '',
        selectedCategory = null,
        favoriteIds = const <int>{},
        isRefreshing = false;

  factory ProductsState.success({
    required List<Product> products,
    required List<String> categories,
    String query = '',
    String? selectedCategory,
    Set<int> favoriteIds = const <int>{},
  }) {
    return ProductsState(
      status: ProductsStatus.success,
      products: products,
      categories: categories,
      query: query,
      selectedCategory: selectedCategory,
      favoriteIds: favoriteIds,
    );
  }

  final ProductsStatus status;

  /// Already filtered by [query] + [selectedCategory].
  final List<Product> products;

  final List<String> categories;
  final String query;
  final String? selectedCategory;
  final Set<int> favoriteIds;

  /// True while a pull-to-refresh is running and old data is still on screen.
  final bool isRefreshing;

  final String? message;

  bool get isLoading => status == ProductsStatus.loading;

  bool get isSuccess => status == ProductsStatus.success;

  bool get isFailure => status == ProductsStatus.failure;

  bool get hasActiveFilter => query.trim().isNotEmpty || selectedCategory != null;

  /// No results *because of a filter* (as opposed to an empty catalog).
  bool get isFilteredEmpty =>
      isSuccess && products.isEmpty && categories.isNotEmpty;

  bool isFavorite(int productId) => favoriteIds.contains(productId);

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    List<String>? categories,
    String? query,
    String? selectedCategory,
    Set<int>? favoriteIds,
    bool? isRefreshing,
    String? message,
    bool clearSelectedCategory = false,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      query: query ?? this.query,
      selectedCategory:
          clearSelectedCategory ? null : selectedCategory ?? this.selectedCategory,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        products,
        categories,
        query,
        selectedCategory,
        favoriteIds,
        isRefreshing,
        message,
      ];
}