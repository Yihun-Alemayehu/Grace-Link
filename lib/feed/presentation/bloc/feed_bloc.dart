import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grace_link/feed/model/comment_model.dart';
import 'package:grace_link/feed/model/like_model.dart';
import 'package:grace_link/feed/model/post_model.dart';
import 'package:grace_link/feed/repos/feed_repo.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepo _feedRepo = FeedRepo();
  FeedBloc() : super(FeedInitial()) {
    on<AddPostEvent>((event, emit) async{
      emit(FeedLoading());
      try {
        final imageUrl = await _feedRepo.addImage(event.image);
        await _feedRepo.addPost(event.text, imageUrl,event.accountType);
        emit(PostAddedstate());
      } catch (e) {
        emit(ErrorState(errorMessage: 'Error occured while adding post $e'));
      }
    });
    on<FetchPostsEvent>((event, emit) async{
      emit(FeedLoading());
      try {
        final posts = await _feedRepo.fetchPosts(postType: event.postType);
        emit(PostsLoaded(posts: posts));
      } catch (e) {
        emit(ErrorState(errorMessage: 'Error occured while adding post $e'));
      }
    });
    on<AddCommentEvent>((event, emit) async{
      emit(FeedLoading());
      try {
        // await _feedRepo.addComment(post: event.post, postType: event.postType);
        // emit(CommentAddedState());
      } catch (e) {
        emit(ErrorState(errorMessage: 'Error occured while adding post $e'));
      }
    });
    on<AddCommentToPostEvent>((event, emit) async{
      // emit(FeedLoading());
      try {
        await _feedRepo.addCommentToPost(event.postId, event.comment, event.postType);
        final posts = await _feedRepo.fetchPosts(postType: event.postTypeTwo);
        emit(PostsLoaded(posts: posts));
      } catch (e) {
        emit(ErrorState(errorMessage: 'Error occured while adding post $e'));
      }
    });
    on<AddLikeToPostEvent>((event, emit) async{
      // emit(FeedLoading());
      try {
        await _feedRepo.addLikeToPost(event.postId, event.like, event.postType);
        final posts = await _feedRepo.fetchPosts(postType: event.postTypeTwo);
        emit(PostsLoaded(posts: posts,));
      } catch (e) {
        emit(ErrorState(errorMessage: 'Error occured while adding post $e'));
      }
    });
  }
}
