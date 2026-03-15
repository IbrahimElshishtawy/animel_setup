import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final String animalType;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.animalType,
  });

  @override
  List<Object?> get props => [id, name, category, price, description, imageUrl, animalType];
}
