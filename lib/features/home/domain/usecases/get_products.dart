import 'package:dartz/dartz.dart';
import 'package:store_app/core/error/failure.dart';
import 'package:store_app/features/home/domain/entities/product.dart';
import 'package:store_app/features/home/domain/repositories/products_repository.dart';

/// Use case: loads the catalog and guarantees a non-null, usable list.
class GetProducts {
  const GetProducts(ProductsRepository repository) : _repository = repository;

  final ProductsRepository _repository;

  Future<Either<Failure, List<Product>>> call() async {
    final result = await _repository.getProducts();
    return result.map(
      // Defensive: an empty list is a valid result, a null one never is.
      (products) => products.where((product) => product.title.isNotEmpty).toList(),
    );
  }
}
