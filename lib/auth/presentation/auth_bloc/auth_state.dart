part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class SignedUpState extends AuthState {
  final MyUser myUser;

  const SignedUpState({required this.myUser});

  @override
  List<Object> get props => [myUser];
}

class SignedInState extends AuthState {
  final User user;

  const SignedInState({required this.user});
  
  @override
  List<Object> get props => [user];
}

class ForgotPasswordState extends AuthState {}

class EmailVerificationSentState extends AuthState {}

class EmailVerifiedState extends AuthState {}

class EmailNotVerifiedState extends AuthState {}

class ErrorState extends AuthState {
  final String errorMessage;

  const ErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
