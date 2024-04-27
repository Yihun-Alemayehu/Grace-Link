import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grace_link/live/config/config.dart';
import 'package:grace_link/live/config/constants.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class LiveScreen extends StatelessWidget {
  final String roomID;
  final bool isHost;
  final LayoutMode layoutMode;
  final User firebaseUser;

  const LiveScreen({
    super.key,
    required this.roomID,
    required this.layoutMode,
    this.isHost = false,
    required this.firebaseUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ZegoUIKitPrebuiltLiveAudioRoom(
            appID: LiveConfig.appId,
            appSign: LiveConfig.appSign,
            userID: localUserID,
            userName: firebaseUser.displayName!,
            roomID: roomID,
            config: (isHost
                ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
                : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
              ..confirmDialogInfo = getDialogInfo()
              ..topMenuBar
              ..duration = ZegoLiveAudioRoomLiveDurationConfig(isVisible: true)
              ..emptyAreaBuilder
              ..seat.takeIndexWhenJoining = isHost ? getHostSeatIndex() : -1
              ..seat.hostIndexes = getLockSeatIndex()
              ..seat.layout = getLayoutConfig()
              ..seat = getSeatConfig()
              ..background = background()
              ..inRoomMessage = getMessageViewConfig()
              ..userAvatarUrl = 'your_avatar_url'
              ..seat.showSoundWaveInAudioMode = true
            // ..onUserCountOrPropertyChanged = (List<ZegoUIKitUser> users) {
            //   debugPrint(
            //       'onUserCountOrPropertyChanged:${users.map((e) => e.toString())}');
            // }
            // ..onSeatClosed = () {
            //   debugPrint('on seat closed');
            // }
            // ..onSeatsOpened = () {
            //   debugPrint('on seat opened');
            // }
            // ..onSeatsChanged = (
            //   Map<int, ZegoUIKitUser> takenSeats,
            //   List<int> untakenSeats,
            // ) {
            //   debugPrint(
            //       'on seats changed, taken seats:$takenSeats, untaken seats:$untakenSeats');
            // }
            // ..onSeatTakingRequested = (ZegoUIKitUser audience) {
            //   debugPrint(
            //       'on seat taking requested, audience:${audience.toString()}');
            // }
            // ..onSeatTakingRequestCanceled = (ZegoUIKitUser audience) {
            //   debugPrint(
            //       'on seat taking request canceled, audience:${audience.toString()}');
            // }
            // ..onInviteAudienceToTakeSeatFailed = () {
            //   debugPrint('on invite audience to take seat failed');
            // }
            // ..onSeatTakingInviteRejected = () {
            //   debugPrint('on seat taking invite rejected');
            // }
            // ..onSeatTakingRequestFailed = () {
            //   debugPrint('on seat taking request failed');
            // }
            // ..onSeatTakingRequestRejected = () {
            //   debugPrint('on seat taking request rejected');
            // }
            // ..onHostSeatTakingInviteSent = () {
            //   debugPrint('on host seat taking invite sent');
            // }

            /// WARNING: will override prebuilt logic
            // ..onSeatClicked = (int index, ZegoUIKitUser? user) {
            //   debugPrint(
            //       'on seat clicked, index:$index, user:${user.toString()}');
            //
            //   showDemoBottomSheet(context);
            // }

            /// WARNING: will override prebuilt logic
            // ..onMemberListMoreButtonPressed = (ZegoUIKitUser user) {
            //   debugPrint(
            //       'on member list more button pressed, user:${user.toString()}');
            //
            //   showDemoBottomSheet(context);
            // },
            ),
      ),
    );
  }

  Widget background() {
    /// how to replace background view
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset('assets/12.png').image,
            ),
          ),
        ),
        Positioned(
            top: 10.h,
            left: 10.w,
            child: Text(
              'GraceLink Live Audio Room',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xff1B1B1B),
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            )),
        Positioned(
          top: 30.h,
          left: 10.w,
          child: Text(
            'ID: $roomID',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xff606060),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }

  ZegoLiveAudioRoomSeatConfig getSeatConfig() {
    if (layoutMode == LayoutMode.hostTopCenter) {
      return ZegoLiveAudioRoomSeatConfig(
        backgroundBuilder: (
          BuildContext context,
          Size size,
          ZegoUIKitUser? user,
          Map<String, dynamic> extraInfo,
        ) {
          return Container(color: Colors.grey);
        },
      );
    }

    return ZegoLiveAudioRoomSeatConfig(
      avatarBuilder: avatarBuilder,
    );
  }

  ZegoLiveAudioRoomDialogInfo getDialogInfo(){
    return ZegoLiveAudioRoomDialogInfo(
      cancelButtonName: 'Cancel',
      confirmButtonName: 'OK',
      title: 'Leave the room',
      message: 'Are you sure to leave the room?',
    );
  }

  ZegoLiveAudioRoomInRoomMessageConfig getMessageViewConfig() {
    return ZegoLiveAudioRoomInRoomMessageConfig(itemBuilder: (
      BuildContext context,
      ZegoInRoomMessage message,
      Map<String, dynamic> extraInfo,
    ) {
      /// how to use itemBuilder to custom message view
      return Stack(
        children: [
          ZegoInRoomMessageViewItem(message: message),

          /// add a red point
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              width: 10,
              height: 10,
            ),
          ),
        ],
      );
    });
  }

  Widget avatarBuilder(BuildContext context, Size size, ZegoUIKitUser? user,
      Map<String, dynamic> extraInfo) {
    return CircleAvatar(
      maxRadius: size.width,
      backgroundImage: firebaseUser.photoURL! == ''
          ? const AssetImage('assets/avatar.png') as ImageProvider<Object>?
          : NetworkImage(firebaseUser.photoURL!),
    );
  }

  int getHostSeatIndex() {
    if (layoutMode == LayoutMode.hostCenter) {
      return 4;
    }

    return 0;
  }

  List<int> getLockSeatIndex() {
    if (layoutMode == LayoutMode.hostCenter) {
      return [4];
    }

    return [0];
  }

  ZegoLiveAudioRoomLayoutConfig getLayoutConfig() {
    final config = ZegoLiveAudioRoomLayoutConfig();
    switch (layoutMode) {
      case LayoutMode.defaultLayout:
        break;
      case LayoutMode.full:
        config.rowSpacing = 5;
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
      case LayoutMode.hostTopCenter:
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 1,
            alignment: ZegoLiveAudioRoomLayoutAlignment.center,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 2,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceEvenly,
          ),
        ];
        break;
      case LayoutMode.hostCenter:
        config.rowSpacing = 5;
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
      case LayoutMode.fourPeoples:
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
    }
    return config;
  }

  void showDemoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0xff111014),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      'Menu $index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
