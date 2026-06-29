import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int    id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Support berbagai format key dari backend
    final id       = (json['ID'] ?? json['id'] ?? json['product_id'] ?? 0) as int;
    final name     = (json['name'] ?? json['product_name'] ?? '') as String;
    final price    = ((json['price'] ?? 0) as num).toDouble();
    final imageUrl = (json['image_url'] ?? json['imageUrl'] ?? json['image'] ?? '') as String;
    final category = (json['category'] ?? json['category_name'] ?? '') as String;
    return ProductModel(id: id, name: name, price: price, imageUrl: imageUrl, category: category);
  }

  @override
  List<Object?> get props => [id, name, price, imageUrl, category];

}