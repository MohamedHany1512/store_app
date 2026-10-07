import 'package:store_app/features/home/domain/entities/product.dart';

/// Data-layer model: parses JSON defensively into a [Product].
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnail,
    required super.price,
    required super.category,
    super.rating,
    super.stock,
    super.discountPercentage,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      thumbnail: (json['thumbnail'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      category: (json['category'] as String?) ?? 'general',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
    );
  }
}
