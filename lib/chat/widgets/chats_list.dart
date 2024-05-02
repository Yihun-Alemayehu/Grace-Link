import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grace_link/chat/providers/get_all_chats_provider.dart';
import 'package:grace_link/chat/widgets/chat_tile.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatsList extends ConsumerWidget {
  const ChatsList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsList = ref.watch(getAllChatsProvider);
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return chatsList.when(
      data: (chats) {
        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats.elementAt(index);
            final userId = chat.members.firstWhere((userId) => userId != myUid);

            return ChatTile(
              userId: userId,
              lastMessage: chat.lastMessage,
              lastMessageTs: chat.lastMessageTs,
              chatroomId: chat.chatroomId,
            );
          },
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return  LoadingAnimationWidget.inkDrop(color: Colors.black, size: 50);
      },
    );
  }
}