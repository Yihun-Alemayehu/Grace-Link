import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ellipsis_text/flutter_ellipsis_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grace_link/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:grace_link/auth/repos/auth_repo.dart';
import 'package:grace_link/feed/model/like_model.dart';
import 'package:grace_link/feed/presentation/bloc/feed_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'post_details_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepo _authRepo = AuthRepo();
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(LoadUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    User? user = _authRepo.getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.adaptive.more_rounded),
            onPressed: () {
              //
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: SingleChildScrollView(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return Center(
                    child: LoadingAnimationWidget.inkDrop(
                        color: Colors.black, size: 50),
                  );
                } else if (state is UserProfileLoadedState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   height: 40.h,
                      // ),
                      Row(
                        children: [
                          Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(45),
                            child: CircleAvatar(
                              radius: 50.r,
                              backgroundImage: state.myUser.profileUrl == ''
                                  ? const AssetImage('assets/avatar.png')
                                      as ImageProvider<Object>?
                                  : NetworkImage(state.myUser.profileUrl),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.myUser.firstName} ${state.myUser.lastName}',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '@${state.myUser.username}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.sp,
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        fixedSize: Size(100.w, 22.h),
                                        backgroundColor: Colors.black),
                                    onPressed: () {},
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        fixedSize: Size(100.w, 22.h),
                                        backgroundColor: Colors.black),
                                    onPressed: () {},
                                    child: Text(
                                      'Message',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(8.r),
                        child: SizedBox(
                          height: 60.h,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      state.myUser.followers.length.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    const Text(
                                      'Followers',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                VerticalDivider(
                                  color: Colors.grey.shade300,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      state.myUser.following.length.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    const Text(
                                      'Following',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                VerticalDivider(
                                  color: Colors.grey.shade300,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      state.userPosts.length.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    const Text(
                                      'Posts',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Posts',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 80.h),
                        height: MediaQuery.of(context).size.height * 0.9.h,
                        child: ListView.builder(
                          itemCount: state.userPosts.length,
                          itemBuilder: (context, index) {
                            final posts = state.userPosts[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Expanded(
                                child: Container(
                                  // height: MediaQuery.of(context).size.height * 0.39.h,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 2.w,
                                                right: 12.w,
                                                top: 8.h,
                                                bottom: 8.h),
                                            child: CircleAvatar(
                                              backgroundImage: posts
                                                          .userImageUrl ==
                                                      ''
                                                  ? const AssetImage(
                                                          'assets/avatar.png')
                                                      as ImageProvider<Object>?
                                                  : NetworkImage(
                                                      posts.userImageUrl),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(posts.userFullName),
                                              Text(
                                                timeago
                                                    .format(posts.timestamp
                                                        .toDate())
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          const Icon(Icons.more_vert_sharp),
                                        ],
                                      ),
                                      EllipsisText(
                                        startScaleIsSmall: true,
                                        text: posts.text,
                                        ellipsis: '... Show More',
                                        maxLines: 3,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PostDetailsScreen(
                                                        post: posts,
                                                        postType:
                                                            'admin_posts'),
                                              ));
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.95.w,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.27.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  posts.imageUrl,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context.read<FeedBloc>().add(
                                                    AddLikeToPostEvent(
                                                        postId: posts.postId,
                                                        like: MyLike(
                                                            uid: user!.uid,
                                                            userFullName: user
                                                                .displayName!,
                                                            userImage:
                                                                user.photoURL!,
                                                            likesCount: 1),
                                                        postType: 'admin_posts',
                                                        postTypeTwo: 'admin'),
                                                  );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 8.h,
                                                  bottom: 0,
                                                  right: 8.w,
                                                  left: 8.w),
                                              height: 31.h,
                                              child: Image.asset(
                                                'assets/heart.png',
                                              ),
                                            ),
                                          ),
                                          Text(
                                            posts.likes.isNotEmpty
                                                ? posts.likes.length.toString()
                                                : ' ',
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
                                                top: 8.h,
                                                bottom: 0,
                                                right: 8.w,
                                                left: 8.w),
                                            height: 31.h,
                                            child: Image.asset(
                                                'assets/comment.png'),
                                          ),
                                          Text(
                                            posts.comments.isNotEmpty
                                                ? posts.comments.length
                                                    .toString()
                                                : ' ',
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
                                                top: 8.h,
                                                bottom: 0,
                                                right: 8.w,
                                                left: 8.w),
                                            height: 31.h,
                                            child:
                                                Image.asset('assets/send.png'),
                                          ),
                                          Text(
                                            '23',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 8.h),
                                            height: 36.h,
                                            child: Image.asset(
                                                'assets/ribbon.png'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
