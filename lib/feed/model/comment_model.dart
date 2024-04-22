// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String userFullName;
  final String userImage;
  final String comment;
  final Timestamp timestamp;

  const Comment({
    required this.userFullName,
    required this.userImage,
    required this.comment,
    required this.timestamp,
  });

  Comment copyWith({
    String? userFullName,
    String? userImage,
    String? comment,
    Timestamp? timestamp,
  }) {
    return Comment(
      userFullName: userFullName ?? this.userFullName,
      userImage: userImage ?? this.userImage,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userFullName': userFullName,
      'userImage': userImage,
      'comment': comment,
      'timestamp': timestamp,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      userFullName: map['userFullName'] as String,
      userImage: map['userImage'] as String,
      comment: map['comment'] as String,
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [userFullName, userImage, comment, timestamp];
}
