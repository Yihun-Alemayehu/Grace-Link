import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grace_link/chat/models/message.dart';

final getAllMessagesProvider = StreamProvider.autoDispose
    .family<Iterable<Message>, String>((ref, String chatroomId) {
  final controller = StreamController<Iterable<Message>>();

  final sub = FirebaseFirestore.instance
      .collection('chat_rooms')
      .doc(chatroomId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .listen((snapshot) {
    final messages = snapshot.docs.map(
      (messageData) => Message.fromMap(
        messageData.data(),
      ),
    );
    controller.sink.add(messages);
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });

  return controller.stream;
});