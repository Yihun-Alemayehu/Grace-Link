import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ellipsis_text/flutter_ellipsis_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:grace_link/auth/repos/auth_repo.dart';
import 'package:grace_link/feed/model/like_model.dart';
import 'package:grace_link/feed/presentation/bloc/feed_bloc.dart';
import 'package:grace_link/feed/presentation/screens/post_details_screen.dart';
import 'package:grace_link/shared/route/routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthRepo _authRepo = AuthRepo();
  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(const FetchPostsEvent(postType: 'admin'));
  }

  @override
  Widget build(BuildContext context) {
    User? user = _authRepo.getCurrentUser();
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
            child: BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                if (state is FeedLoading) {
                  return Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.inkDrop(
                          color: Colors.black, size: 50),
                    ],
                  ));
                } else if (state is PostsLoaded) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 80.h),
                    height: MediaQuery.of(context).size.height * 0.9.h,
                    child: ListView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final posts = state.posts[index];
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          backgroundImage:
                                              posts.userImageUrl == ''
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
                                                .format(
                                                    posts.timestamp.toDate())
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
                                                    postType: 'admin_posts'),
                                          ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95.w,
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                                        userFullName:
                                                            user.displayName!,
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
                                        child:
                                            Image.asset('assets/comment.png'),
                                      ),
                                      Text(
                                        posts.comments.isNotEmpty
                                            ? posts.comments.length.toString()
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
                                        child: Image.asset('assets/send.png'),
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
                                            horizontal: 12.w, vertical: 8.h),
                                        height: 36.h,
                                        child: Image.asset('assets/ribbon.png'),
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
