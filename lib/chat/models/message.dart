// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String message;
  final String messageId;
  final String senderId;
  final String receiverId;
  final Timestamp timestamp;
  final bool seen;
  final String messageType;

  const Message({
    required this.message,
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.seen,
    required this.messageType,
  });

  Message copyWith({
    String? message,
    String? messageId,
    String? senderId,
    String? receiverId,
    Timestamp? timestamp,
    bool? seen,
    String? messageType,
  }) {
    return Message(
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      timestamp: timestamp ?? this.timestamp,
      seen: seen ?? this.seen,
      messageType: messageType ?? this.messageType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,
      'seen': seen,
      'messageType': messageType,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] as String,
      messageId: map['messageId'] as String,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      timestamp: map['timestamp'] ?? Timestamp.now(),
      seen: map['seen'] as bool,
      messageType: map['messageType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      message,
      messageId,
      senderId,
      receiverId,
      timestamp,
      seen,
      messageType,
    ];
  }
}
