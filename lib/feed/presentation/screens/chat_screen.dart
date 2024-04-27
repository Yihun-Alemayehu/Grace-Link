import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 45.h,
              child: Image.asset(
                'assets/messenger.png',
              ),
            ),
            Text(
              'Coming soon...!',
              style: TextStyle(
                fontSize: 30.sp,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
