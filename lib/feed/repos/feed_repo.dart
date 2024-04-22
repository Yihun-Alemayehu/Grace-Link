import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grace_link/feed/model/post_model.dart';
import 'package:uuid/uuid.dart';

class FeedRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _cloud = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // add Post
  Future<void> addPost(String text, String imageUrl, String accountType) async {
    try {
      final user = _auth.currentUser!;
      String collectionName = '';
      if (accountType == 'user') {
        collectionName = 'posts';
      } else if (accountType == 'admin') {
        collectionName = 'admin_posts';
      }
      final postId = await _cloud.collection(collectionName).add({
        'text': text,
        'imageUrl': imageUrl,
        'userId': user.uid,
        'userImageUrl': user.photoURL,
        'userFullName': user.displayName,
        'likes': [],
        'comments': [],
        'shares': [],
        'timestamp': Timestamp.now(),
        'post-id': ''
      });
      await _cloud.collection(collectionName).doc(postId.id).update({
        'post-id': postId.id,
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

  // Fetch posts
  Future<List<MyPost>> fetchPosts({required String postType}) async {
    try {
      String collectionName = '';
      if (postType == 'user') {
        collectionName = 'posts';
      } else if (postType == 'admin') {
        collectionName = 'admin_posts';
      }
      final result = await _cloud.collection(collectionName).get();
      List<MyPost> posts = result.docs.map((doc) {
        return MyPost.fromMap(doc.data());
      }).toList();
      return posts;
    } catch (e) {
      debugPrint('Error while fetching posts ${e.toString()}');
      return [];
    }
  }

  // Add comment
  Future<void> addComment({required MyPost post, required String postType}) async {
    try {
      await _cloud.collection(postType).doc(post.postId).update(
        {
          'text': post.text,
        'imageUrl': post.imageUrl,
        'userId': post.userId,
        'userImageUrl': post.userImageUrl,
        'userFullName': post.userFullName,
        'likes': [],
        'comments': post.comments,
        'shares': [],
        'timestamp': post.timestamp,
        'post-id': post.postId,
        }
      );
    } catch (e) {
      debugPrint('Error while fetching posts ${e.toString()}');
    }
  }
}
