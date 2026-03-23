import 'package:equatable/equatable.dart';
import 'user_model.dart';

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
  final UserProfile? owner;
  final String healthStatus;
  final DateTime? createdAt;

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
    this.owner,
    required this.healthStatus,
    this.createdAt,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    final ownerJson = json['ownerId'];
    final resolvedOwnerId = ownerJson is Map<String, dynamic>
        ? ownerJson['_id']?.toString() ?? ''
        : json['ownerId']?.toString() ?? '';

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
      ownerId: resolvedOwnerId,
      owner: ownerJson is Map<String, dynamic>
          ? UserProfile.fromJson(ownerJson)
          : null,
      healthStatus: json['healthStatus'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'gender': gender,
      'size': size,
      'price': price,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'imageUrls': imageUrls,
      'isForAdoption': isForAdoption,
      'healthStatus': healthStatus,
    };
  }

  Animal copyWith({
    String? id,
    String? name,
    String? type,
    String? breed,
    String? age,
    String? gender,
    String? size,
    double? price,
    String? location,
    double? latitude,
    double? longitude,
    String? description,
    List<String>? imageUrls,
    bool? isForAdoption,
    String? ownerId,
    UserProfile? owner,
    String? healthStatus,
    DateTime? createdAt,
  }) {
    return Animal(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      size: size ?? this.size,
      price: price ?? this.price,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      isForAdoption: isForAdoption ?? this.isForAdoption,
      ownerId: ownerId ?? this.ownerId,
      owner: owner ?? this.owner,
      healthStatus: healthStatus ?? this.healthStatus,
      createdAt: createdAt ?? this.createdAt,
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
        owner,
        healthStatus,
        createdAt,
      ];
}
