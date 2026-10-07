import 'package:equatable/equatable.dart';

/// Domain entity for a product.
///
/// Note it is a pure Dart object: no `fromJson`, no nullable soup, and a
/// [copyWith] for safe updates.
class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.price,
    required this.category,
    this.rating = 0,
    this.stock = 0,
    this.discountPercentage,
  });

  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final double price;
  final String category;
  final double rating;
  final int stock;

  /// Optional discount shown as a badge on the card.
  final double? discountPercentage;

  bool get isInStock => stock > 0;

  /// Price after applying [discountPercentage].
  double get finalPrice {
    final discount = discountPercentage;
    if (discount == null || discount <= 0) {
      return price;
    }
    return price * (1 - discount / 100);
  }

  Product copyWith({
    int? id,
    String? title,
    String? description,
    String? thumbnail,
    double? price,
    String? category,
    double? rating,
    int? stock,
    double? discountPercentage,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      price: price ?? this.price,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      discountPercentage: discountPercentage ?? this.discountPercentage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        description,
        thumbnail,
        price,
        category,
        rating,
        stock,
        discountPercentage,
      ];
}
