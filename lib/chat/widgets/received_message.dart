import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grace_link/chat/models/message.dart';
import 'package:grace_link/chat/widgets/message_content.dart';
import 'package:grace_link/chat/widgets/round_profile_tile.dart';

class ReceivedMessage extends ConsumerWidget {
  final Message message;

  const ReceivedMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          RoundProfileTile(url: message.senderId),
          const SizedBox(width: 15),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: MessageContents(message: message),
            ),
          ),
        ],
      ),
    );
  }
}