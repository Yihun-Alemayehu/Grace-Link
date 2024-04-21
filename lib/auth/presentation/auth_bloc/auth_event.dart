part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  const SignUpEvent(
      {required this.email, required this.password, required this.fullName});

  @override
  List<Object> get props => [email, password, fullName];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class VerifyEmailEvent extends AuthEvent {}

class EmailVerifiedEvent extends AuthEvent {}

class ReloadUserEvent extends AuthEvent {}
