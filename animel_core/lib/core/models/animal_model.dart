import 'package:equatable/equatable.dart';

class Animal extends Equatable {
  final String id;
  final String name;
  final String type;
  final String breed;
  final String age;
  final String gender;
  final String size;
  final double price;
  final String location;
  final String description;
  final List<String> imageUrls;
  final bool isForAdoption;
  final String ownerId;
  final String healthStatus;

  const Animal({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.gender,
    required this.size,
    required this.price,
    required this.location,
    required this.description,
    required this.imageUrls,
    required this.isForAdoption,
    required this.ownerId,
    required this.healthStatus,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? '',
      gender: json['gender'] ?? '',
      size: json['size'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      isForAdoption: json['isForAdoption'] ?? false,
      ownerId: json['ownerId'] ?? '',
      healthStatus: json['healthStatus'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        breed,
        age,
        gender,
        size,
        price,
        location,
        description,
        imageUrls,
        isForAdoption,
        ownerId,
        healthStatus,
      ];
}
