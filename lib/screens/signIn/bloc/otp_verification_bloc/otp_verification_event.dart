part of 'otp_verification_bloc.dart';

abstract class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object> get props => [];
}

class OtpEnteredEvent extends OtpVerificationEvent {
  final String otpEntered;
  OtpEnteredEvent(this.otpEntered);
}

class ResendOtp extends OtpVerificationEvent {}

class OtpVerificationCompleted extends OtpVerificationEvent {
  final AuthCredential credential;
  OtpVerificationCompleted(this.credential);
}

class OtpVerificationFailed extends OtpVerificationEvent {
  final FirebaseAuthException authException;

  OtpVerificationFailed(this.authException);
}

class OtpCodeSent extends OtpVerificationEvent {
  final String verificationId;
  final int forceResendToken;

  OtpCodeSent(this.verificationId, this.forceResendToken);
}

class OtpCodeAutoRetrievalTimeout extends OtpVerificationEvent {
  final String verificationId;

  OtpCodeAutoRetrievalTimeout(this.verificationId);
}
