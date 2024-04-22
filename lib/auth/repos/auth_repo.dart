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

  // get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // sign up the user
  Future<MyUser?> signUp(
      {required String email,
      required String password,
      required String fullName}) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCred.user;

      await _cloud.collection('users').doc(user!.uid).set({
        'uid': user.uid,
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
      await user.updateDisplayName(fullName);
      final interUser =
          await _cloud.collection('users').doc(userCred.user!.uid).get();
      return MyUser.fromMap(interUser.data()!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      debugPrint(
          'Error has occured while creating user account ${e.toString()}');
      return null;
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
  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
      return null;
    } catch (e) {
      debugPrint('Error has occured while signing in user ${e.toString()}');
      return null;
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

  // Forgot Password
  Future<void> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error has occured while forgetting out user ${e.toString()}');
    }
  }

  // verify Email
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } catch (e) {
      debugPrint(
          'Error has occured while sending email verification ${e.toString()}');
    }
  }

  // reload the user
  Future<User?> reloadUser() async {
    try {
      await _auth.currentUser!.reload();
      return _auth.currentUser!;
    } catch (e) {
      debugPrint('Error has occured while reloading user ${e.toString()}');
      return null;
    }
  }
}
