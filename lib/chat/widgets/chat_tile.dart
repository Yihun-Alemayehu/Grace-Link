import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grace_link/chat/providers/get_user_info_by_id_provider.dart';
import 'package:grace_link/chat/screens/chat_room.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatTile extends ConsumerWidget {
  const ChatTile({
    super.key,
    required this.userId,
    required this.lastMessage,
    required this.lastMessageTs,
    required this.chatroomId,
  });

  final String userId;
  final String lastMessage;
  final Timestamp lastMessageTs;
  final String chatroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(getUserInfoByIdProvider(userId));

    return userInfo.when(
      data: (user) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomScreen(userId: userId),));
            },
            child: Row(
              children: [
                // Profile Pic
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(user.profileUrl),
                ),
                const SizedBox(width: 10),
                // Column (Name + Last Message + Last Message Timetstamp)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Last Message + Ts
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              lastMessage,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            timeago.format(lastMessageTs.toDate()),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Message status
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.check,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Container(
          width: double.infinity,
          height: 50,
          color: Colors.grey,
          child: Center(
            child: Text(error.toString()),
          ),
        );
      },
      loading: () {
        return Container(
          width: double.infinity,
          height: 50,
          color: Colors.grey,
        );
      },
    );
  }
}