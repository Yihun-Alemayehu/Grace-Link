import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grace_link/auth/models/user_model.dart';
import 'package:grace_link/auth/repos/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo = AuthRepo();
  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async{
      emit(AuthLoading());
      try {
        final result = await _authRepo.signUp(email: event.email, password: event.password, fullName: event.fullName);
        emit(SignedUpState(myUser: result!));
      } catch (e) {
        debugPrint('Error while emitting signed Up state  ${e.toString()}');
      }
    });
  }
}
