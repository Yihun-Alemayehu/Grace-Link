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
