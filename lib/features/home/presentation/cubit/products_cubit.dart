import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/home/domain/entities/product.dart';
import 'package:store_app/features/home/domain/usecases/get_products.dart';

part 'products_state.dart';

/// Drives the product catalog: loading, searching, filtering and favourites.
///
/// Filtering happens **in the Cubit**, not in the widget: the view stays
/// declarative and rebuilds only when the state actually changes.
class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({required GetProducts getProducts})
      : _getProducts = getProducts,
        super(const ProductsState.initial());

  final GetProducts _getProducts;

  List<Product> _allProducts = const <Product>[];
  String _query = '';
  String? _category;

  /// Called when the page is first built.
  Future<void> loadProducts() async {
    if (_allProducts.isNotEmpty) {
      await refresh(silent: true);
      return;
    }
    await _fetch();
  }

  /// Pull-to-refresh: keeps the current list visible while reloading.
  Future<void> refresh({bool silent = false}) => _fetch(silent: silent);

  Future<void> _fetch({bool silent = false}) async {
    final current = state;

    if (silent && current.status == ProductsStatus.success) {
      // Silent refresh: keep the list visible, show a thin progress bar.
      emit(current.copyWith(isRefreshing: true));
    } else {
      emit(const ProductsState.loading());
    }

    final result = await _getProducts();
    if (isClosed) {
      return;
    }

    result.fold(
      (failure) => emit(
        ProductsState.failure(
          message: failure.message,
          // Preserve previously loaded items so a failed refresh does not
          // wipe the screen.
          products: _allProducts,
        ),
      ),
      (products) {
        _allProducts = products;
        _category = null;
        emit(_successState());
      },
    );
  }

  /// Re-runs the active filters against the cached catalog.
  void search(String query) {
    if (_query == query) {
      return;
    }
    _query = query;
    if (_allProducts.isEmpty) {
      return;
    }
    emit(_successState());
  }

  void selectCategory(String? category) {
    if (_category == category) {
      return;
    }
    _category = category;
    if (_allProducts.isEmpty) {
      return;
    }
    emit(_successState());
  }

  void toggleFavorite(int productId) {
    if (_allProducts.isEmpty) {
      return;
    }
    final next = Set<int>.of(state.favoriteIds);
    if (!next.remove(productId)) {
      next.add(productId);
    }
    emit(state.copyWith(favoriteIds: next));
  }

  void clearFilters() {
    if (_query.isEmpty && _category == null) {
      return;
    }
    _query = '';
    _category = null;
    if (_allProducts.isEmpty) {
      return;
    }
    emit(_successState());
  }

  ProductsState _successState() {
    return ProductsState.success(
      products: _filteredProducts(),
      categories: _categories(),
      query: _query,
      selectedCategory: _category,
      favoriteIds: state.favoriteIds,
    );
  }

  List<Product> _filteredProducts() {
    final query = _query.trim().toLowerCase();
    final category = _category;

    return _allProducts.where((product) {
      final matchesQuery = query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);

      final matchesCategory = category == null || product.category == category;

      return matchesQuery && matchesCategory;
    }).toList(growable: false);
  }

  List<String> _categories() {
    final categories = _allProducts.map((product) => product.category).toSet();
    final sorted = categories.toList()..sort();
    return List<String>.unmodifiable(sorted);
  }
}
