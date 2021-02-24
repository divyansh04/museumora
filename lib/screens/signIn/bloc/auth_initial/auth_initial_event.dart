part of 'auth_initial_bloc.dart';

abstract class AuthInitialEvent extends Equatable {
  const AuthInitialEvent();

  @override
  List<Object> get props => [];
}

class GoogleSignInEvent extends AuthInitialEvent {}

class FacebookSignInEvent extends AuthInitialEvent {}

class ForgotPasswordEvent extends AuthInitialEvent {}

class LogInByEmail extends AuthInitialEvent {
  final String email, pass;
  LogInByEmail(this.email, this.pass);
}

class SignUpByEmail extends AuthInitialEvent {
  final String name, email, phone;
  SignUpByEmail(this.name, this.email, this.phone);
}

class AuthInitialVerificationComplete extends AuthInitialEvent {
  final AuthCredential credential;
  final String email, name;
  AuthInitialVerificationComplete(this.credential, this.email, this.name);
}

class AuthInitialVerificationFailed extends AuthInitialEvent {
  final FirebaseAuthException exception;

  AuthInitialVerificationFailed(this.exception);
}

class AuthInitialCodeSent extends AuthInitialEvent {
  final String verificationId,phone, email, name;
  final int forceResendToken;
  AuthInitialCodeSent(this.verificationId,this.phone, this.email, this.name, this.forceResendToken);
}
