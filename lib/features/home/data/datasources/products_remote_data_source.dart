import 'package:dio/dio.dart';
import 'package:store_app/core/constants/api_endpoints.dart';
import 'package:store_app/features/home/data/models/product_model.dart';

abstract interface class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

/// Thin REST adapter for `/products`.
class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  const ProductsRemoteDataSourceImpl(Dio dio) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.products);

    final data = response.data;
    final products = data?['products'];

    if (products is! List) {
      return const <ProductModel>[];
    }

    return products
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .toList(growable: false);
  }
}
