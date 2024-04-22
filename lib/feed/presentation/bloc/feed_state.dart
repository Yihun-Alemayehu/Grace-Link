part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();
  
  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class PostAddedstate extends FeedState{}

class ErrorState extends FeedState {
  final String errorMessage;

  const ErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class PostsLoaded extends FeedState {
  final List<MyPost> posts;

  const PostsLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class CommentAddedState extends FeedState {}