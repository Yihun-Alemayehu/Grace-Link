import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ellipsis_text/flutter_ellipsis_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grace_link/auth/repos/auth_repo.dart';
import 'package:grace_link/feed/model/comment_model.dart';
import 'package:grace_link/feed/model/post_model.dart';
import 'package:grace_link/feed/presentation/bloc/feed_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailsScreen extends StatefulWidget {
  final MyPost post;
  final String postType;
  const PostDetailsScreen(
      {super.key, required this.post, required this.postType});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final AuthRepo _authRepo = AuthRepo();
  @override
  Widget build(BuildContext context) {
    User? user = _authRepo.getCurrentUser();
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                                  widget.post.likes.isNotEmpty
                                      ? widget.post.likes.length.toString()
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
                                  child: Image.asset('assets/comment.png'),
                                ),
                                Text(
                                  widget.post.comments.length.toString(),
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
                                itemCount: widget.post.comments.length,
                                itemBuilder: (context, index) {
                                  var commentfinal = Comment(
                                      userFullName: 'userFullName',
                                      userImage: 'userImage',
                                      comment: 'comment',
                                      timestamp: Timestamp.now());
                                  if (state is CommentAddedState) {
                                    commentfinal =
                                        Comment.fromMap(state.comments[index]);
                                  } else if (state is PostsLoaded) {
                                    final post = state.posts.firstWhere(
                                        (element) =>
                                            element.postId ==
                                            widget.post.postId);
                                    commentfinal =
                                        Comment.fromMap(post.comments[index]);
                                    debugPrint('---------------------post id-------------'); 
                                    debugPrint(post.postId); 
                                    debugPrint('---------------------post id-------------'); 
                                    debugPrint('---------------------widget.post.post id-------------'); 
                                    debugPrint(widget.post.postId); 
                                    debugPrint('---------------------widget.post.post id-------------'); 
                                  } else {
                                    commentfinal = Comment.fromMap(
                                        widget.post.comments[index]);
                                  }

                                  return SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                backgroundImage: commentfinal
                                                            .userImage ==
                                                        ''
                                                    ? const AssetImage(
                                                            'assets/avatar.png')
                                                        as ImageProvider<
                                                            Object>?
                                                    : NetworkImage(
                                                        commentfinal.userImage),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(commentfinal.userFullName),
                                                Text(
                                                  timeago.format(commentfinal
                                                      .timestamp
                                                      .toDate()),
                                                  style: const TextStyle(
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
                                          child: EllipsisText(
                                            startScaleIsSmall: true,
                                            text: commentfinal.comment,
                                            ellipsis: '... Show More',
                                            maxLines: 3,
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 0.3,
                                          color: Colors.grey,
                                        )
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
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .5,
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextField(
                          autofocus: true,
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Comment here ...',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            context.read<FeedBloc>().add(
                                  AddCommentToPostEvent(
                                    postId: widget.post.postId,
                                    comment: Comment(
                                      userFullName: user!.displayName!,
                                      userImage: user.photoURL ?? '',
                                      comment: _commentController.text,
                                      timestamp: Timestamp.now(),
                                    ),
                                    postType: widget.postType,
                                    postTypeTwo: widget.postType == 'admin_posts' ? 'admin': 'user',
                                  ),
                                );
                            Navigator.pop(context);
                          },
                          icon: SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset('assets/send_comment.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: 60.h,
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: const Text('Comment here...'),
                      ),
                    )),
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
                    // MyPost updatedPost = widget.post.copyWith(
                    //     comments: List<dynamic>.from(widget.post.comments)
                    //       ..add({
                    //         'userFullName': widget.post.userFullName,
                    //         'userImage': widget.post.userImageUrl,
                    //         'comment': _commentController.text,
                    //         'timestamp': Timestamp.now(),
                    //       }));

                    // MyPost updatedPost = widget.post.copyWith(comments: [
                    //   ...widget.post.comments,
                    //   {
                    //     'userFullName': widget.post.userFullName,
                    //     'userImage': widget.post.userImageUrl,
                    //     'comment': _commentController.text,
                    //     'timestamp': Timestamp.now(),
                    //   }
                    // ]);
                    // debugPrint(updatedPost.toString());

                    // context.read<FeedBloc>().add(
                    //       AddCommentEvent(
                    //         post: updatedPost,
                    //         postType: 'admin_posts',
                    //       ),
                    //     );

                    // context.read<FeedBloc>().add(
                    //       AddCommentToPostEvent(
                    //         postId: widget.post.postId,
                    //         comment: Comment(
                    //           userFullName: user!.displayName!,
                    //           userImage: user.photoURL ?? '',
                    //           comment: _commentController.text,
                    //           timestamp: Timestamp.now(),
                    //         ),
                    //         postType: widget.postType,
                    //       ),
                    //     );
                  },
                  icon: SizedBox(
                    child: Image.asset('assets/send_comment.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
