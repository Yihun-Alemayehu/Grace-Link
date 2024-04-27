import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grace_link/live/config/constants.dart';
import 'package:grace_link/live/presentation/screens/live_screen.dart';

class ZegoCloudScreen extends StatelessWidget {
  ZegoCloudScreen({super.key});

  /// Users who use the same liveID can join the same live audio room.
  final roomIDTextCtrl =
      TextEditingController(text: Random().nextInt(10000).toString());
  final layoutValueNotifier =
      ValueNotifier<LayoutMode>(LayoutMode.defaultLayout);

  @override
  Widget build(BuildContext context) {
  User? firebaseUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID:$localUserID'),
            // const Text('Please test with two or more devices'),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Layout : '),
                  switchDropList<LayoutMode>(
                    layoutValueNotifier,
                    [
                      LayoutMode.defaultLayout,
                      LayoutMode.full,
                      LayoutMode.hostTopCenter,
                      LayoutMode.hostCenter,
                      LayoutMode.fourPeoples,
                    ],
                    (LayoutMode layoutMode) {
                      return Text(layoutMode.text);
                    },
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: roomIDTextCtrl,
              decoration: const InputDecoration(labelText: 'join a live by id'),
            ),
            SizedBox(height: 20.h),
            // click me to navigate to LivePage
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(305.w, 48.h), backgroundColor: Colors.black),
              onPressed: () {
                jumpToLivePage(
                  context,
                  roomID: roomIDTextCtrl.text.trim(),
                  isHost: true,
                  firebaseUser: firebaseUser,
                );
              },
              child: Text(
                'Start a live',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21.sp,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(305.w, 48.h), backgroundColor: Colors.black),
              onPressed: () {
                jumpToLivePage(
                  context,
                  roomID: roomIDTextCtrl.text.trim(),
                  isHost: false,
                  firebaseUser: firebaseUser,
                );
              },
              child: Text(
                'Watch a live',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void jumpToLivePage(BuildContext context,
      {required String roomID, required bool isHost, required User? firebaseUser}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveScreen(
          roomID: roomID,
          isHost: isHost,
          layoutMode: layoutValueNotifier.value,
          firebaseUser: firebaseUser!,
        ),
      ),
    );
  }

  Widget switchDropList<T>(
    ValueNotifier<T> notifier,
    List<T> itemValues,
    Widget Function(T value) widgetBuilder,
  ) {
    return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: (context, value, _) {
        return DropdownButton<T>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: itemValues.map((T itemValue) {
            return DropdownMenuItem(
              value: itemValue,
              child: widgetBuilder(itemValue),
            );
          }).toList(),
          onChanged: (T? newValue) {
            if (newValue != null) {
              notifier.value = newValue;
            }
          },
        );
      },
    );
  }
}
