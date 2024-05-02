import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grace_link/chat/repo/chat_repo.dart';

final chatProvider = Provider(
  (ref) => ChatRepo(),
);