import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String profileImageUrl;
  final String location;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileImageUrl,
    required this.location,
  });

  @override
  List<Object?> get props => [id, name, email, phoneNumber, profileImageUrl, location];
}
