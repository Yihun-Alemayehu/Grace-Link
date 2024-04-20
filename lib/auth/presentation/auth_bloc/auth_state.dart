part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class SignedUpState extends AuthState{
  final MyUser myUser;

  const SignedUpState({required this.myUser});

  @override
  List<Object> get props => [myUser];
}
