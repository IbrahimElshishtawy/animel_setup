import 'package:equatable/equatable.dart';
import 'user_model.dart';

class Conversation extends Equatable {
  final String id;
  final List<UserProfile> participants;
  final String lastMessage;
  final DateTime? lastMessageAt;

  const Conversation({
    required this.id,
    required this.participants,
    required this.lastMessage,
    this.lastMessageAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id']?.toString() ?? '',
      participants: (json['participants'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(UserProfile.fromJson)
          .toList(),
      lastMessage: json['lastMessage']?.toString() ?? '',
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'].toString())
          : null,
    );
  }

  UserProfile? get otherParticipant =>
      participants.isNotEmpty ? participants.first : null;

  @override
  List<Object?> get props => [id, participants, lastMessage, lastMessageAt];
}
