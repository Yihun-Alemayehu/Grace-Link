import 'package:flutter/material.dart';
import 'package:grace_link/chat/models/message.dart';
import 'package:grace_link/chat/widgets/post_image_video_view.dart';

class MessageContents extends StatelessWidget {
  const MessageContents({
    super.key,
    required this.message,
    this.isSentMessage = false,
  });

  final Message message;
  final bool isSentMessage;

  @override
  Widget build(BuildContext context) {
    if (message.messageType == 'text') {
      return Text(
        message.message,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isSentMessage ? Colors.white : Colors.black,
        ),
      );
    } else {
      return PostImageVideoView(
        fileUrl: message.message,
        fileType: message.messageType,
      );
    }
  }
}