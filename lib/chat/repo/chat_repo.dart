import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grace_link/chat/models/chat_room.dart';
import 'package:grace_link/chat/models/message.dart';
import 'package:uuid/uuid.dart';

class ChatRepo {
  final FirebaseFirestore _cloud = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Create chat room
  Future<String> createChatRoom({required String userId}) async {
    try {
      CollectionReference chatRooms = _cloud.collection('chat_rooms');

      // sorted members
      final sortedMembers = [uid, userId]..sort((a, b) => a.compareTo(b));

      // existing chat room
      QuerySnapshot existingChatRooms =
          await chatRooms.where('members', isEqualTo: sortedMembers).get();

      if (existingChatRooms.docs.isNotEmpty) {
        return existingChatRooms.docs.first.id;
      } else {
        final chatRoomId = const Uuid().v1();

        ChatRoom chatroom = ChatRoom(
          chatroomId: chatRoomId,
          lastMessage: '',
          lastMessageTs: DateTime.now(),
          members: sortedMembers,
          createdAt: DateTime.now(),
        );

        await _cloud.collection('chat_rooms').doc(chatRoomId).set(
              chatroom.toMap(),
            );

        return chatRoomId;
      }
    } catch (e) {
      return "Error creating chat room : ${e.toString()}";
    }
  }

  // Send message
  Future<String?> sendMessage(
      {required String message,
      required String chatRoomId,
      required receiverId}) async {
    try {
      final messageId = const Uuid().v1();

      Message newMessage = Message(
          message: message,
          messageId: messageId,
          senderId: uid,
          receiverId: receiverId,
          timestamp: DateTime.now(),
          seen: false,
          messageType: 'text');

      DocumentReference myChatroomRef =
          FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId);

      await myChatroomRef.collection('messages').doc(messageId).set(
            newMessage.toMap(),
          );

      await myChatroomRef.update({
        'lastMessage': message,
        'lastMessageTs': DateTime.now(),
      });
      return null;
    } catch (e) {
      return "Error sending message : ${e.toString()}";
    }
  }

  // Send File Message
  Future<String?> sendFileMessage({
    required File file,
    required String chatroomId,
    required String receiverId,
    required String messageType,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      // Save to storage
      Reference ref = _storage.ref(messageType).child(messageId);
      TaskSnapshot snapshot = await ref.putFile(file);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      Message newMessage = Message(
        message: downloadUrl,
        messageId: messageId,
        senderId: uid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: messageType,
      );

      DocumentReference myChatroomRef = FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatroomId);

      await myChatroomRef
          .collection('messages')
          .doc(messageId)
          .set(newMessage.toMap());

      await myChatroomRef.update({
        'lastMessage': 'send a $messageType',
        'lastMessageTs': now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // seen message
  Future<String?> seenMessage({
    required String chatroomId,
    required String messageId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatroomId)
          .collection('messages')
          .doc(messageId)
          .update({
        'seen': true,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
