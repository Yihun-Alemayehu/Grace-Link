import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ellipsis_text/flutter_ellipsis_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grace_link/feed/model/post_model.dart';
import 'package:grace_link/feed/presentation/bloc/feed_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PostDetailsScreen extends StatefulWidget {
  final MyPost post;
  const PostDetailsScreen({super.key, required this.post});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
          child: SingleChildScrollView(
            child: BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                if (state is FeedLoading) {
                  return Center(
                    child: LoadingAnimationWidget.inkDrop(
                        color: Colors.black, size: 50),
                  );
                }
                return SizedBox(
                  // padding: EdgeInsets.only(bottom: 10.h),
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
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
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: EllipsisText(
                                startScaleIsSmall: true,
                                text: widget.post.text,
                                ellipsis: '... Show More',
                                maxLines: 3,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.95.w,
                                height:
                                    MediaQuery.of(context).size.height * 0.27.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      widget.post.imageUrl,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 8.h,
                                      bottom: 0,
                                      right: 8.w,
                                      left: 8.w),
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
                                      top: 8.h,
                                      bottom: 0,
                                      right: 8.w,
                                      left: 8.w),
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
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6.w, top: 10.h),
                              child: Text(
                                'Comments',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: 8,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 2.w,
                                                  right: 12.w,
                                                  top: 8.h,
                                                  bottom: 8.h),
                                              child: const CircleAvatar(
                                                backgroundColor: Colors.white,
                                                backgroundImage: '' == ''
                                                    ? AssetImage(
                                                            'assets/avatar.png')
                                                        as ImageProvider<
                                                            Object>?
                                                    : NetworkImage(
                                                        'posts.userImageUrl'),
                                              ),
                                            ),
                                            const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Yihun Alemayehu'),
                                                Text(
                                                  '3 days ago',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            const Icon(Icons.more_vert_sharp),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 55.w),
                                          child: const EllipsisText(
                                            startScaleIsSmall: true,
                                            text:
                                                'Oh, how abundant is your goodness, which you have stored up for those who fear you and worked for those who take refuge in you, in the sight of the children of mankind!',
                                            ellipsis: '... Show More',
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                      // prefixIcon: const Icon(Icons.comment),
                      hintText: 'Comment here ...',
                      // fillColor: Theme.of(context).colorScheme.primaryContainer,
                      // filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      )),
                ),
              ),
              IconButton(
                onPressed: () {
                  // MyPost updatedPost = widget.post.copyWith(
                  //   comments: List<Comment>.from(widget.post.comments)..add(
                  //     Comment(
                  //         userFullName: widget.post.userFullName,
                  //         userImage: widget.post.userImageUrl,
                  //         comment: _commentController.text,
                  //         timestamp: Timestamp.now())
                  //   )
                  // );
                  MyPost updatedPost = widget.post.copyWith(
                      comments: List<dynamic>.from(widget.post.comments)
                        ..add({
                          'userFullName': widget.post.userFullName,
                          'userImage': widget.post.userImageUrl,
                          'comment': _commentController.text,
                          'timestamp': Timestamp.now(),
                        }));
                  debugPrint(updatedPost.toString());

                  context.read<FeedBloc>().add(
                        AddCommentEvent(
                          post: updatedPost,
                          postType: 'admin_posts',
                        ),
                      );
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
