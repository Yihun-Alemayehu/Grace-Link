import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grace_link/chat/providers/chat_provider.dart';
import 'package:grace_link/chat/widgets/chat_user_info.dart';
import 'package:grace_link/chat/widgets/messages_list.dart';
import 'package:grace_link/shared/utils/util.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  const ChatRoomScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  static const routeName = '/chat-screen';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  late final TextEditingController messageController;
  late final String chatroomId;

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.watch(chatProvider).createChatRoom(userId: widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingAnimationWidget.inkDrop(color: Colors.black, size: 50);
        }

        chatroomId = snapshot.data ?? 'No chatroom Id';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(
                Icons.arrow_back_ios,
                // color: AppColors.messengerBlue,
              ),
            ),
            titleSpacing: 0,
            title: ChatUserInfo(
              userId: widget.userId,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: MessagesList(
                  chatroomId: chatroomId,
                ),
              ),
              const Divider(),
              _buildMessageInput(),
            ],
          ),
        );
      },
    );
  }

  // Chat Text Field
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.image,
              color: Colors.grey,
            ),
            onPressed: () async {
              final image = await pickImage();
              if (image == null) return;
              await ref.read(chatProvider).sendFileMessage(
                    file: image,
                    chatroomId: chatroomId,
                    receiverId: widget.userId,
                    messageType: 'image',
                  );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.video_call_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () async {
              final video = await pickVideo();
              if (video == null) return;
              await ref.read(chatProvider).sendFileMessage(
                    file: video,
                    chatroomId: chatroomId,
                    receiverId: widget.userId,
                    messageType: 'video',
                  );
            },
          ),
          // Text Field
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Aa',
                  hintStyle: TextStyle(),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    left: 20,
                    bottom: 10,
                  ),
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: Colors.black,
            ),
            onPressed: () async {
              // Add functionality to handle send button press
              await ref.read(chatProvider).sendMessage(
                    message: messageController.text,
                    chatRoomId: chatroomId,
                    receiverId: widget.userId,
                  );
              messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}