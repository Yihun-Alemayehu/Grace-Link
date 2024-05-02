import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grace_link/chat/models/message.dart';
import 'package:grace_link/chat/widgets/message_content.dart';

class SentMessage extends ConsumerWidget {
  final Message message;

  const SentMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 15),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
              ),
              child: Wrap(
                children: [
                  MessageContents(
                    message: message,
                    isSentMessage: true,
                  ),
                  const SizedBox(width: 5),
                  message.seen
                      ? const Icon(
                          Icons.done_all,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.check,
                          color:  Colors.white,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}