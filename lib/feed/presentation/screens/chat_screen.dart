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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Message'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: IconButton(
              onPressed: () async {
                // await FirebaseAuth.instance.signOut();
                // Get.toNamed(RouteClass.login);
              },
              icon: Icon(Icons.adaptive.more_outlined),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .9,
                  height: MediaQuery.of(context).size.height * .06,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Expanded(
                    child: Material(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(17)),
                      child: TextFormField(
                        onTap: () {},
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: const TextStyle(
                              fontSize: 17, color: Colors.black),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.black,
                          ),
                          fillColor: Colors.white60.withOpacity(0.08),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'All Chats',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .7,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const ListTile(
                        leading: CircleAvatar(),
                        title: Text('Zerihun Kassahun'),
                        subtitle: Text('ok, I\'ll try to do it'),
                        trailing: Text('3 minutes ago'),
                      );
                    },),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
