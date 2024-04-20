// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  final String uid;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String profileUrl;
  final String coverUrl;
  final String bio;
  final String accountType;
  final String gender;
  final List<String> following;
  final List<String> followers;
  final List<String> posts;

  const MyUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.profileUrl,
    required this.coverUrl,
    required this.bio,
    required this.accountType,
    required this.gender,
    required this.following,
    required this.followers,
    required this.posts,
  });


  MyUser copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? profileUrl,
    String? coverUrl,
    String? bio,
    String? accountType,
    String? gender,
    List<String>? following,
    List<String>? followers,
    List<String>? posts,
  }) {
    return MyUser(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      profileUrl: profileUrl ?? this.profileUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      bio: bio ?? this.bio,
      accountType: accountType ?? this.accountType,
      gender: gender ?? this.gender,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      posts: posts ?? this.posts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'profileUrl': profileUrl,
      'coverUrl': coverUrl,
      'bio': bio,
      'accountType': accountType,
      'gender': gender,
      'following': following,
      'followers': followers,
      'posts': posts,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      uid: map['uid'] as String,
      firstName: map['first-name'] as String,
      lastName: map['last-name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      profileUrl: map['profile-url'] as String,
      coverUrl: map['cover-url'] as String,
      bio: map['bio'] as String,
      accountType: map['account-type'] as String,
      gender: map['gender'] as String,
      following: List<String>.from((map['following'] ?? [])),
      followers: List<String>.from((map['followers'] ?? [])),
      posts: List<String>.from((map['posts'] ?? [])),
    );
  }

  String toJson() => json.encode(toMap());

  factory MyUser.fromJson(String source) => MyUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      uid,
      firstName,
      lastName,
      username,
      email,
      profileUrl,
      coverUrl,
      bio,
      accountType,
      gender,
      following,
      followers,
      posts,
    ];
  }
}
