part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class AddPostEvent extends FeedEvent {
  final String text;
  final File image;

  const AddPostEvent({required this.text, required this.image});

  @override
  List<Object> get props => [text];
}
