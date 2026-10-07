import 'package:dartz/dartz.dart';
import 'package:store_app/core/error/failure.dart';
import 'package:store_app/features/home/domain/entities/product.dart';

/// Domain contract implemented in `data`.
abstract interface class ProductsRepository {
  Future<Either<Failure, List<Product>>> getProducts();
}
