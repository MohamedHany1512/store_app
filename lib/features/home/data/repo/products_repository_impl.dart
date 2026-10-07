import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/error/failure.dart';
import 'package:store_app/features/home/data/datasources/products_remote_data_source.dart';
import 'package:store_app/features/home/domain/entities/product.dart';
import 'package:store_app/features/home/domain/repositories/products_repository.dart';

/// Maps transport errors to typed failures - the single place in the Home
/// feature where a `DioException` is interpreted.
class ProductsRepositoryImpl implements ProductsRepository {
  const ProductsRepositoryImpl({required ProductsRemoteDataSource remote})
      : _remote = remote;

  final ProductsRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await _remote.getProducts();
      return Right(products);
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        return Left(
          ServerFailure('Server error ($statusCode). ${AppStrings.serverError}'),
        );
      }
      return const Left(NetworkFailure());
    } on FormatException {
      return const Left(ServerFailure('Unexpected response from the server'));
    } catch (_) {
      return const Left(ServerFailure(AppStrings.genericError));
    }
  }
}
