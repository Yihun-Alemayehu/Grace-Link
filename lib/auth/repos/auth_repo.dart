import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grace_link/auth/models/user_model.dart';
import 'package:uuid/uuid.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _cloud = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // sign up the user
  Future<MyUser?> signUp({required String email, required String password, required String fullName}) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _cloud.collection('users').doc(userCred.user!.uid).set({
        'uid': userCred.user!.uid,
        'first-name': fullName.split(' ')[0],
        'last-name': fullName.split(' ')[1],
        'username': '',
        'email': email,
        'profile-url': '',
        'cover-url': '',
        'bio': '',
        'account-type': 'user',
        'gender': '',
        'following': const [],
        'followers': const [],
        'posts': const [],
      });
      final interUser =  await _cloud.collection('users').doc(userCred.user!.uid).get();
      return MyUser.fromMap(interUser.data()!);
    } catch (e) {
      debugPrint(
          'Error has occured while creating user account ${e.toString()}');
    }
  }

  // complete user profile
  Future<void> completeUserProfile(
      {required String uid,
      required String firstName,
      required String lastName,
      required String userName,
      required String profileUrl,
      required String coverUrl,
      required String bio,
      required String gender}) async {
    try {
      await _cloud.collection('users').doc(uid).update({
        'first-name': firstName,
        'last-name': lastName,
        'username': userName,
        'profile-url': profileUrl,
        'cover-url': coverUrl,
        'bio': bio,
        'gender': gender,
      });
      await _auth.currentUser!.updateDisplayName('$firstName $lastName');
      await _auth.currentUser!.updatePhotoURL(profileUrl);
    } catch (e) {
      debugPrint(
          'Error has occured while completing user profile ${e.toString()}');
    }
  }

  // upload profile image
  Future<String> uploadProfileImage(
      {required String uid, required File imageFile}) async {
    try {
      final String randomImageName = '${const Uuid().v4()}.jpg';
      final storageRef = _storage.ref().child('$uid/profile/$randomImageName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      await _cloud.collection('users').doc(uid).update({
        'image-url': imageUrl,
      });
      await _auth.currentUser!.updatePhotoURL(imageUrl);
      return imageUrl;
    } catch (e) {
      debugPrint(
          'Error has occured while uploading profile image ${e.toString()}');
      return '';
    }
  }

  // upload profile image
  Future<String> uploadCoverImage(
      {required String uid, required File imageFile}) async {
    try {
      final String randomImageName = '${const Uuid().v4()}.jpg';
      final storageRef = _storage.ref().child('$uid/cover/$randomImageName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      await _cloud.collection('users').doc(uid).update({
        'image-url': imageUrl,
      });
      return imageUrl;
    } catch (e) {
      debugPrint(
          'Error has occured while uploading cover image ${e.toString()}');
      return '';
    }
  }

  // update profile image
  Future<void> updateProfileImage(
      {required String userId, required File imageFile}) async {
    try {
      final imageUrl =
          await uploadProfileImage(uid: userId, imageFile: imageFile);
      await _cloud.collection('users').doc(userId).update({
        'image-url': imageUrl,
      });
      await _auth.currentUser!.updatePhotoURL(imageUrl);
    } catch (e) {
      debugPrint(
          'Error has occured while updating profile image ${e.toString()}');
    }
  }

  // sign in the user
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Error has occured while signing in user ${e.toString()}');
    }
  }

  // sign out the user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error has occured while signing out user ${e.toString()}');
    }
  }
}
