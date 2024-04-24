// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class MyLike extends Equatable {
  final String uid;
  final String userFullName;
  final String userImage;
  final int likesCount;

  const MyLike({
    required this.uid,
    required this.userFullName,
    required this.userImage,
    required this.likesCount,
  });

  MyLike copyWith({
    String? uid,
    String? userFullName,
    String? userImage,
    int? likesCount,
  }) {
    return MyLike(
      uid: uid ?? this.uid,
      userFullName: userFullName ?? this.userFullName,
      userImage: userImage ?? this.userImage,
      likesCount: likesCount ?? this.likesCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userFullName': userFullName,
      'userImage': userImage,
      'likesCount': likesCount,
    };
  }

  factory MyLike.fromMap(Map<String, dynamic> map) {
    return MyLike(
      uid: map['uid'] as String,
      userFullName: map['userFullName'] as String,
      userImage: map['userImage'] as String,
      likesCount: map['likesCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyLike.fromJson(String source) => MyLike.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [userFullName, userImage, likesCount];
}
