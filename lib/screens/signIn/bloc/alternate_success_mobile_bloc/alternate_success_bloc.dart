import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:museumora/services/moduleServices/authentication_service.dart';
import 'package:museumora/services/moduleServices/userServices.dart';
import 'package:museumora/services/serviceLocator.dart';
import 'package:museumora/widgets/error_dialog.dart';

import '../../enter_otp_screen.dart';

part 'alternate_success_event.dart';
part 'alternate_success_state.dart';

class AlternateSuccessBloc
    extends Bloc<AlternateSuccessEvent, AlternateSuccessState> {
  final BuildContext context;

  AlternateSuccessBloc(this.context) : super(AlternateSuccessInitial());
  @override
  Stream<AlternateSuccessState> mapEventToState(
    AlternateSuccessEvent event,
  ) async* {
    if (event is AddPhoneEvent) {
      yield AlternateSuccessLoading();
      try {
        Map<String, dynamic> phoneExists = await use
            .get<AuthenticationService>()
            .checkIfPhoneExists(event.mobileNo);
        //If there's some email which is added with this phone
        String email = use.get<UserService>().user.email;
        // if (response != null && response != email) {
        if (phoneExists['exists'] && phoneExists['email'] != email) {
          yield AlternateSuccessInitial();
          ErrorDialog.showErrorDialog(context,
              error:
                  "This mobile number is already in use by another email address.");
        } else {
          await _verifyPhoneNumber(event.mobileNo);
        }
      } catch (e) {
        ErrorDialog.showErrorDialog(context,
            error: "Oops! Couldn't verify your mobile number.");
        yield AlternateSuccessInitial();
      }
    }
    if (event is VerificationCompleted) {
      AuthCredential credential = event.credential;
      if (credential != null) {
        try {
          await use.get<UserService>().user.linkWithCredential(credential);
          await use.get<AuthenticationService>().logUserIntoApp(context);
        } on FirebaseAuthException catch (e) {
          String errorMessage;
          /*final f = [
            'provider-already-linked',
            'invalid-credential',
            'credential-already-in-use',
            'email-already-in-use',
            'operation-not-allowed',
            'invalid-email',
            'invalid-verification-code',
            'invalid-verification-id',
          ];*/
          switch (e.code) {
            case 'invalid-credential':
              errorMessage = 'OTP entered is incorrect';
              break;
            case 'ERROR_USER_DISABLED':
              errorMessage = 'This account is temporarily disabled';
              break;
            case 'credential-already-in-use':
              errorMessage = 'This account exists';
              break;
            case 'operation-not-allowed':
              errorMessage = 'Service temporarily disabled';
              break;
            case 'invalid-verification-code':
              errorMessage = 'OTP is incorrect or expired';
              break;
            default:
              errorMessage = 'Oops! There was some issue in verification';
          }
          //Show reason of failure
          ErrorDialog.showErrorDialog(
            context,
            error: errorMessage,
          );
        }
      }
      yield AlternateSuccessInitial();
    }
    if (event is VerificationFailed) {
      //Show reason of failure
      yield AlternateSuccessInitial();
      ErrorDialog.showErrorDialog(context, error: event.exception.message);
    }
    if (event is CodeSent) {
      yield AlternateSuccessInitial();
      //Go to next screen
      Navigator.pushNamed(
        context,
        OTPVerificationScreen.routeName,
        arguments: OTPVerificationScreen(
          fromAlternateProvider: true,
          phoneNo: event.phoneNumber,
          verificationId: event.verificationId,
          forceResendToken: event.forceResendToken,
        ),
      );
    }
    if (event is CodeAutoRetrivalTimeout) {
      yield AlternateSuccessInitial();
    }
  }

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential credential) {
          add(VerificationCompleted(credential));
        },
        verificationFailed: (FirebaseAuthException authException) {
          add(VerificationFailed(authException));
        },
        codeSent: (String verificationId, [int forceResendToken]) {
          add(CodeSent(verificationId, phoneNumber, forceResendToken));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          add(CodeAutoRetrivalTimeout(verificationId));
        },
      );
    } catch (e) {
      print(e.toString());
      ErrorDialog.showErrorDialog(context,
          error: "There seems an error during mobile verification.");
    }
  }
}
