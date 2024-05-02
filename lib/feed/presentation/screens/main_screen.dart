import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grace_link/feed/presentation/screens/add_post_screen.dart';
import 'package:grace_link/chat/screens/chat_screen.dart';
import 'package:grace_link/feed/presentation/screens/community_screen.dart';
import 'package:grace_link/feed/presentation/screens/home_screen.dart';
import 'package:grace_link/feed/presentation/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const CommunityScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPostScreen(),
                ));
          },
          child: const Icon(Icons.add,
          color: Colors.white,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          height: 50.h,
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          surfaceTintColor: Colors.black,
          notchMargin: 8,
          child: SizedBox(
            height: 30.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  minWidth: 40.w,
                  onPressed: () {
                    setState(() {
                      currentScreen = const HomeScreen();
                      currentTab = 0;
                    });
                  },
                  child: SizedBox(
                    height: 25.h,
                    child: Image.asset(
                      'assets/home.png',
                      color: 0 == currentTab ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const CommunityScreen();
                      currentTab = 1;
                    });
                  },
                  child: Icon(
                    Icons.diversity_1,
                    color: 1 == currentTab ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const ChatScreen();
                      currentTab = 2;
                    });
                  },
                  child: SizedBox(
                    height: 25.h,
                    child: Image.asset(
                      'assets/messenger.png',
                      color: 2 == currentTab ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const ProfileScreen();
                      currentTab = 3;
                    });
                  },
                  child: SizedBox(
                    height: 25.h,
                    child: Image.asset(
                      'assets/user.png',
                      color: 3 == currentTab ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
