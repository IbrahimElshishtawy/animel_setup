import 'package:equatable/equatable.dart';
import 'user_journey.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final UserJourney? journey;
  final String? profileImageUrl;
  final String? location;
  final String language;
  final String? bio;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.journey,
    this.profileImageUrl,
    this.location,
    this.language = 'en',
    this.bio,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      journey: UserJourneyX.fromStorage(json['journey']?.toString()),
      profileImageUrl: json['profileImageUrl'],
      location: json['location'],
      language: json['language'] ?? 'en',
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'journey': journey?.storageValue,
      'profileImageUrl': profileImageUrl,
      'location': location,
      'language': language,
      'bio': bio,
    };
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    UserJourney? journey,
    String? profileImageUrl,
    String? location,
    String? language,
    String? bio,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      journey: journey ?? this.journey,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      language: language ?? this.language,
      bio: bio ?? this.bio,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        journey,
        profileImageUrl,
        location,
        language,
        bio,
      ];
}
