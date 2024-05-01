import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grace_link/auth/models/user_model.dart';
import 'package:grace_link/auth/repos/auth_repo.dart';
import 'package:grace_link/feed/model/post_model.dart';
import 'package:grace_link/feed/repos/feed_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo = AuthRepo();
  final FeedRepo _feedRepo = FeedRepo();
  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await _authRepo.signUp(
            email: event.email,
            password: event.password,
            fullName: event.fullName);
        emit(SignedUpState(myUser: result!));
      } catch (e) {
        debugPrint('Error while emitting signed Up state  ${e.toString()}');
        emit(ErrorState(errorMessage: e.toString()));
      }
    });
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCred = await _authRepo.signIn(
            email: event.email, password: event.password);
        if (userCred != null) {
          emit(SignedInState(user: userCred));
        } else {
          emit(const ErrorState(errorMessage: 'Wrong email or password'));
        }
      } catch (e) {
        debugPrint('Error while emitting signed In state  ${e.toString()}');
        emit(ErrorState(errorMessage: e.toString()));
      }
    });
    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepo.forgotPassword(email: event.email);
        emit(ForgotPasswordState());
      } catch (e) {
        debugPrint('Error while emitting signed In state  ${e.toString()}');
        emit(ErrorState(errorMessage: e.toString()));
      }
    });
    on<VerifyEmailEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepo.sendEmailVerification();
        emit(EmailVerificationSentState());
      } catch (e) {
        debugPrint(
            'Error while emitting email Verification state  ${e.toString()}');
        emit(ErrorState(errorMessage: e.toString()));
      }
    });
    on<ReloadUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final myUser = await _authRepo.reloadUser();
        if (myUser!.emailVerified) {
          emit(EmailVerifiedState());
        } else {
          emit(EmailNotVerifiedState());
        }
      } catch (e) {
        debugPrint(
            'Error while emitting email Verification state  ${e.toString()}');
        emit(ErrorState(errorMessage: e.toString()));
      }
    });
    on<CompleteProfileEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final imageUrl =
            await _authRepo.uploadProfileImage(imageFile: event.profileImage);
        await _authRepo.completeUserProfile(
            userName: event.username,
            profileUrl: imageUrl,
            bio: event.bio,
            gender: event.gender);
        emit(ProfileCompletedState());
      } catch (e) {
        debugPrint('Error while profile compeleted state  ${e.toString()}');
        emit(ErrorState(errorMessage: e.toString()));
      }
    });
    on<LoadUserProfileEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final myUser = await _authRepo.getCurrentMyUser();
        final userPosts =
            await _feedRepo.fetchUserPosts(postType: myUser!.accountType);
        emit(UserProfileLoadedState(myUser: myUser, userPosts: userPosts));
      } catch (e) {
        debugPrint(
            'Error while emiting UserProfileLoaded state  ${e.toString()}');
        emit(ErrorState(errorMessage: e.toString()));
      }
    });
  }
}
