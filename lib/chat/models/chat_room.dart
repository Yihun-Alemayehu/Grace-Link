// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  final String chatroomId;
  final String lastMessage;
  final Timestamp lastMessageTs;
  final List<String> members;
  final Timestamp createdAt;

  const ChatRoom({
    required this.chatroomId,
    required this.lastMessage,
    required this.lastMessageTs,
    required this.members,
    required this.createdAt,
  });

  ChatRoom copyWith({
    String? chatroomId,
    String? lastMessage,
    Timestamp? lastMessageTs,
    List<String>? members,
    Timestamp? createdAt,
  }) {
    return ChatRoom(
      chatroomId: chatroomId ?? this.chatroomId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTs: lastMessageTs ?? this.lastMessageTs,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatroomId': chatroomId,
      'lastMessage': lastMessage,
      'lastMessageTs': lastMessageTs,
      'members': members,
      'createdAt': createdAt,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      chatroomId: map['chatroomId'] as String,
      lastMessage: map['lastMessage'] as String,
      lastMessageTs: map['lastMessageTs'] ?? Timestamp.now(),
      members: List<String>.from(map['members'].map((x) => x as String)),
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) => ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      chatroomId,
      lastMessage,
      lastMessageTs,
      members,
      createdAt,
    ];
  }
}
