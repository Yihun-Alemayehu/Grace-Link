import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grace_link/auth/models/user_model.dart';

final getUserInfoByIdProvider =
    FutureProvider.autoDispose.family< MyUser, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get()
      .then((userData) {
    return MyUser.fromMap(userData.data()!);
  });
});