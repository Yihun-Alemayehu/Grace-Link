part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class AddPostEvent extends FeedEvent {
  final String text;
  final File image;
  final String accountType;

  const AddPostEvent({required this.text, required this.image, required this.accountType});

  @override
  List<Object> get props => [text];
}

class FetchPostsEvent extends FeedEvent {
  final String postType;

  const FetchPostsEvent({required this.postType});

  @override
  List<Object> get props => [postType];
}

class AddCommentEvent extends FeedEvent {
  final MyPost post;
  final String postType;

  const AddCommentEvent({required this.post, required this.postType});
  
  @override
  List<Object> get props => [post, postType];
}
class AddCommentToPostEvent extends FeedEvent {
  final String postId;
  final Comment comment;
  final String postType;
  final String postTypeTwo;

  const AddCommentToPostEvent({required this.postId, required this.comment, required this.postType, required this.postTypeTwo});
  
  @override
  List<Object> get props => [postId, comment];
}

class AddLikeToPostEvent extends FeedEvent {
  final String postId;
  final MyLike like;
  final String postType;
  final String postTypeTwo;

  const AddLikeToPostEvent({required this.postId, required this.like, required this.postType, required this.postTypeTwo});

  @override
  List<Object> get props => [postId, like, postType];
}
