import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:museumora/services/moduleServices/authentication_service.dart';
import 'package:museumora/services/moduleServices/userServices.dart';
import 'package:museumora/services/serviceLocator.dart';
import 'package:museumora/widgets/error_dialog.dart';

import '../../create_password_screen.dart';

part 'otp_verification_event.dart';
part 'otp_verification_state.dart';

class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final BuildContext context;
  String verificationId;
  final bool fromAlternateProvider;
  final String name, email;
  int forceResendToken;
  final String phoneNumber;
  OtpVerificationBloc(
    this.context, {
    @required this.verificationId,
    @required this.fromAlternateProvider,
    @required this.forceResendToken,
    @required this.phoneNumber,
    this.name,
    this.email,
  }) : super(OtpVerificationInitial());

  @override
  Stream<OtpVerificationState> mapEventToState(
    OtpVerificationEvent event,
  ) async* {
    yield OTPVerificationLoading();
    if (event is OtpEnteredEvent) {
      String response = await _checkIfOtpIsCorrect(event.otpEntered);
      if (response != "success") {
        //If fails
        if (_checkIfAutomaticOtpRetrieved()) {
          await _onVerificationSuccess();
        } else {
          ErrorDialog.showErrorDialog(context, error: response);
        }
        yield OtpVerificationInitial();
      } else {
        await _onVerificationSuccess();
      }
      yield OtpVerificationInitial();
    }
    if (event is ResendOtp) {
      await _resendOtpCode();
      yield OtpVerificationInitial();
    }
    if (event is OtpVerificationCompleted) {
      String response = await _verifyCredentials(event.credential);
      if (response != "success") {
        ErrorDialog.showErrorDialog(context, error: response);
      } else {
        await _onVerificationSuccess();
      }
      yield OtpVerificationInitial();
    }
    if (event is OtpVerificationFailed) {
      ErrorDialog.showErrorDialog(context, error: event.authException.message);
    }
    if (event is OtpCodeSent) {
      this.verificationId = event.verificationId;
      this.forceResendToken = event.forceResendToken;
      yield OtpVerificationInitial();
    }
    if (event is OtpCodeAutoRetrievalTimeout) {
      this.verificationId = event.verificationId;
      yield OtpVerificationInitial();
    }
  }

  ///
  ///Checks if otp entered is correct
  ///returns error message in case of failure otherwise
  ///Signs user with credentials is Email Pass signup is done
  ///else links with the ucrrent user
  ///
  Future<String> _checkIfOtpIsCorrect(String otp) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: this.verificationId, smsCode: otp);
      if (credential == null) {
        //ERROR
        return "OTP is incorrect or expired";
      }
      UserCredential authResult;
      if (this.fromAlternateProvider) {
        authResult =
            await use.get<UserService>().user.linkWithCredential(credential);
      } else {
        authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
      }
      if (authResult.user != null) {
        use.get<UserService>().setUser(authResult.user);
        return "success";
      } else {
        return "Oops! Sign In failed";
      }
    } catch (e) {
      return e.message;
    }
  }

  Future<void> _resendOtpCode() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNumber,
        timeout: Duration(seconds: 30),
        verificationCompleted: (phoneAuthCredential) {
          add(OtpVerificationCompleted(phoneAuthCredential));
        },
        verificationFailed: (error) {
          add(OtpVerificationFailed(error));
        },
        codeSent: (verificationId, [forceResendingToken]) {
          add(OtpCodeSent(verificationId, forceResendToken));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          add(OtpCodeAutoRetrievalTimeout(verificationId));
        },
        forceResendingToken: this.forceResendToken,
      );
    } catch (e) {
      print(e.toString());
      ErrorDialog.showErrorDialog(context,
          error: "There seems an error during mobile verification.");
    }
  }

  Future<void> _onVerificationSuccess() async {
    if (fromAlternateProvider) {
      await use.get<AuthenticationService>().logUserIntoApp(context);
    } else {
      Navigator.pushReplacementNamed(
        context,
        CreatePasswordScreen.routeName,
        arguments: CreatePasswordScreen(name: name, email: email),
      );
    }
  }

  Future<String> _verifyCredentials(AuthCredential credential) async {
    String errorMessage;
    if (fromAlternateProvider) {
      try {
        UserCredential authResult =
            await use.get<UserService>().user.linkWithCredential(credential);
        use.get<UserService>().setUser(authResult.user);
      } catch (e) {
        errorMessage = e.message;
      }
    } else {
      try {
        UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        use.get<UserService>().setUser(authResult.user);
      } catch (e) {
        errorMessage = e.message;
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    } else {
      return "success";
    }
  }

  bool _checkIfAutomaticOtpRetrieved() {
    User user = use.get<UserService>().user;
    return (user != null &&
        user.phoneNumber != null &&
        user.phoneNumber.isNotEmpty &&
        user.phoneNumber == phoneNumber);
  }
}
