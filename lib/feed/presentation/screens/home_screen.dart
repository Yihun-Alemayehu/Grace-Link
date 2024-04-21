import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:grace_link/shared/route/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('GraceLink'),
        actions: [
          const Icon(Icons.sensors_rounded),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.toNamed(RouteClass.login);
              },
              icon: const Icon(Icons.notifications_active),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: 10.h),
              height: MediaQuery.of(context).size.height * 0.9.h,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.39.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(2, 2),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 2.w,
                                    right: 12.w,
                                    top: 8.h,
                                    bottom: 8.h),
                                child: const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/copy.jpg'),
                                ),
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Yihun Alemayehu'),
                                  Text(
                                    '3 days ago',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.more_vert_sharp),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95.w,
                            height: MediaQuery.of(context).size.height * 0.27.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                image: NetworkImage(
                                    'https://i.pinimg.com/236x/e7/c6/33/e7c6331e8b62a18c131342ca567757dd.jpg'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    top: 8.h, bottom: 0, right: 8.w, left: 8.w),
                                height: 31.h,
                                child: Image.asset('assets/heart.png'),
                              ),
                              Text(
                                '100',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 8.h, bottom: 0, right: 8.w, left: 8.w),
                                height: 31.h,
                                child: Image.asset('assets/comment.png'),
                              ),
                              Text(
                                '74',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 8.h, bottom: 0, right: 8.w, left: 8.w),
                                height: 31.h,
                                child: Image.asset('assets/send.png'),
                              ),
                              Text(
                                '23',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 8.h),
                                height: 36.h,
                                child: Image.asset('assets/ribbon.png'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
