import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FeedRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _cloud = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // add Post
  Future<void> addPost(String text, String imageUrl) async {
    try {
      await _cloud.collection('posts').add({
        'text': text,
        'imageUrl': imageUrl,
        'userId': _auth.currentUser!.uid,
        'likes': [],
        'comments': [],
        'shares': [],
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      debugPrint('Error while adding post ${e.toString()}');
    }
  }

  // Add Image
  Future<String> addImage(File image) async {
    try {
      final uid = _auth.currentUser!.uid;
      final String randomImageName = '${const Uuid().v4()}.jpg';
      final storageRef = _storage.ref().child('$uid/posts/$randomImageName');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      debugPrint('Error while adding image ${e.toString()}');
      return '';
    }
  }
}