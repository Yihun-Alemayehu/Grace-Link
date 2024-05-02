import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grace_link/chat/providers/get_user_info_by_id_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatUserInfo extends ConsumerWidget {
  const ChatUserInfo({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      getUserInfoByIdProvider(userId),
    );

    return userInfo.when(
      data: (user) {
        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.profileUrl),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user.firstName} ${user.lastName}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'Messenger',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ],
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