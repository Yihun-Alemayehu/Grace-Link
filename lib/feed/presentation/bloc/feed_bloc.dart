import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
        await _feedRepo.addPost(event.text, imageUrl);
        emit(PostAddedstate());
      } catch (e) {
        emit(ErrorState(errorMessage: 'Error occured while adding post $e'));
      }
    });
  }
}
