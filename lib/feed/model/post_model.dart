// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MyPost extends Equatable {
  final String text;
  final String imageUrl;
  final String userId;
  final String userImageUrl;
  final String userFullName;
  final List<String> likes;
  final List<String> comments;
  final List<String> shares;
  final Timestamp timestamp;

  const MyPost({
    required this.text,
    required this.imageUrl,
    required this.userId,
    required this.userImageUrl,
    required this.userFullName,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.timestamp,
  });

  MyPost copyWith({
    String? text,
    String? imageUrl,
    String? userId,
    String? userImageUrl,
    String? userFullName,
    List<String>? likes,
    List<String>? comments,
    List<String>? shares,
    Timestamp? timestamp,
  }) {
    return MyPost(
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      userId: userId ?? this.userId,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      userFullName: userFullName ?? this.userFullName,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'imageUrl': imageUrl,
      'userId': userId,
      'userImageUrl': userImageUrl,
      'userFullName': userFullName,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'timestamp': timestamp,
    };
  }

  factory MyPost.fromMap(Map<String, dynamic> map) {
    return MyPost(
      text: map['text'] as String,
      imageUrl: map['imageUrl'] as String,
      userId: map['userId'] as String,
      userImageUrl: map['userImageUrl'] as String,
      userFullName: map['userFullName'] as String,
      likes: List<String>.from((map['likes'] ?? [])),
      comments: List<String>.from((map['comments'] ?? [])),
      shares: List<String>.from((map['shares'] ?? [])),
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MyPost.fromJson(String source) => MyPost.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      text,
      imageUrl,
      userId,
      userImageUrl,
      userFullName,
      likes,
      comments,
      shares,
      timestamp,
    ];
  }
}
