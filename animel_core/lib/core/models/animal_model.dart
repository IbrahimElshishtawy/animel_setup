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
  final double latitude;
  final double longitude;
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
    required this.latitude,
    required this.longitude,
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
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
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
        latitude,
        longitude,
        description,
        imageUrls,
        isForAdoption,
        ownerId,
        healthStatus,
      ];
}
