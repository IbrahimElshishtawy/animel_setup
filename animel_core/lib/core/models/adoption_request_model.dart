import 'package:equatable/equatable.dart';
import 'animal_model.dart';
import 'user_model.dart';

class AdoptionRequestModel extends Equatable {
  final String id;
  final Animal? animal;
  final UserProfile? requester;
  final UserProfile? owner;
  final String message;
  final String status;
  final DateTime? createdAt;

  const AdoptionRequestModel({
    required this.id,
    required this.animal,
    required this.requester,
    required this.owner,
    required this.message,
    required this.status,
    this.createdAt,
  });

  factory AdoptionRequestModel.fromJson(Map<String, dynamic> json) {
    return AdoptionRequestModel(
      id: json['_id']?.toString() ?? '',
      animal: json['animalId'] is Map<String, dynamic>
          ? Animal.fromJson(json['animalId'] as Map<String, dynamic>)
          : null,
      requester: json['requesterId'] is Map<String, dynamic>
          ? UserProfile.fromJson(json['requesterId'] as Map<String, dynamic>)
          : null,
      owner: json['ownerId'] is Map<String, dynamic>
          ? UserProfile.fromJson(json['ownerId'] as Map<String, dynamic>)
          : null,
      message: json['message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  @override
  List<Object?> get props => [id, animal, requester, owner, message, status, createdAt];
}
