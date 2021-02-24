part of 'otp_verification_bloc.dart';

abstract class OtpVerificationState extends Equatable {
  const OtpVerificationState();

  @override
  List<Object> get props => [];
}

class OtpVerificationInitial extends OtpVerificationState {}

class OTPVerificationLoading extends OtpVerificationState {}
