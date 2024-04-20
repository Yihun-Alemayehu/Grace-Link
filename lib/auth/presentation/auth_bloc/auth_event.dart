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
      {required this.email, required this.password,required this.fullName});

  @override
  List<Object> get props => [email, password, fullName ];
}
