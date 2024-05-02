import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grace_link/chat/providers/chat_provider.dart';
import 'package:grace_link/chat/providers/get_all_messages_provider.dart';
import 'package:grace_link/chat/widgets/received_message.dart';
import 'package:grace_link/chat/widgets/send_message.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MessagesList extends ConsumerWidget {
  const MessagesList({
    super.key,
    required this.chatroomId,
  });

  final String chatroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesList = ref.watch(getAllMessagesProvider(chatroomId));
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return messagesList.when(
      data: (messages) {
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages.elementAt(index);
            final isMyMessage = message.senderId == myUid;

            if (!isMyMessage) {
              ref.read(chatProvider).seenMessage(
                    chatroomId: chatroomId,
                    messageId: message.messageId,
                  );
            }

            if (isMyMessage) {
              return SentMessage(message: message);
            } else {
              return ReceivedMessage(message: message);
            }
          },
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return LoadingAnimationWidget.inkDrop(color: Colors.black, size: 50);
      },
    );
  }
}