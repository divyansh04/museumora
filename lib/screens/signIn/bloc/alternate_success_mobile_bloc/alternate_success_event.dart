part of 'alternate_success_bloc.dart';

abstract class AlternateSuccessEvent extends Equatable {
  const AlternateSuccessEvent();
  @override
  List<Object> get props => [];
}

class AddPhoneEvent extends AlternateSuccessEvent {
  final String mobileNo;
  AddPhoneEvent(this.mobileNo);
}

class VerificationCompleted extends AlternateSuccessEvent {
  final AuthCredential credential;

  VerificationCompleted(this.credential);
}

class VerificationFailed extends AlternateSuccessEvent {
  final FirebaseAuthException exception;

  VerificationFailed(this.exception);
}

class CodeSent extends AlternateSuccessEvent {
  final String verificationId;
  final String phoneNumber;
  final int forceResendToken;

  CodeSent(this.verificationId, this.phoneNumber, this.forceResendToken);
}

class CodeAutoRetrivalTimeout extends AlternateSuccessEvent {
  final String verificationId;

  CodeAutoRetrivalTimeout(this.verificationId);
}
