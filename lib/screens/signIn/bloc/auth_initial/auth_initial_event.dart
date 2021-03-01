part of 'auth_initial_bloc.dart';

abstract class AuthInitialEvent extends Equatable {
  const AuthInitialEvent();

  @override
  List<Object> get props => [];
}

class GoogleSignInEvent extends AuthInitialEvent {}

class ForgotPasswordEvent extends AuthInitialEvent {}

class LogInByEmail extends AuthInitialEvent {
  final String email, pass;
  LogInByEmail(this.email, this.pass);
}

class SignUpByEmail extends AuthInitialEvent {
  final String name, email;
  SignUpByEmail(this.name, this.email);
}
