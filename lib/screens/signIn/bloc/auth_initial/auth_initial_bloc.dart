import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museumora/services/moduleServices/authentication_service.dart';
import 'package:museumora/services/moduleServices/userServices.dart';
import 'package:museumora/services/serviceLocator.dart';
import 'package:museumora/widgets/error_dialog.dart';

import '../../alternate_auth_success_screen.dart';
import '../../create_password_screen.dart';
import '../../enter_otp_screen.dart';
import '../../forgot_password_screen.dart';

part 'auth_initial_event.dart';
part 'auth_initial_state.dart';

class AuthInitialBloc extends Bloc<AuthInitialEvent, AuthInitialState> {
  final BuildContext context;
  AuthInitialBloc(this.context) : super(AuthInitialInitial());

  @override
  Stream<AuthInitialState> mapEventToState(
    AuthInitialEvent event,
  ) async* {
    yield AuthInitialLoading();
    if (event is GoogleSignInEvent) {
      try {
        String response =
            await use.get<AuthenticationService>().signInWithGoogle();
        if (response != "success") {
          ErrorDialog.showErrorDialog(context, error: response);
        } else if (use.get<UserService>().user.phoneNumber != null) {
          //If phone already exists, log him in
          await use
              .get<AuthenticationService>()
              .logUserIntoApp(context, newAccount: false);
        } else {
          //If phone does not exists, redirect to add phone screen
          Navigator.pushNamed(
            context,
            AlternateAuthSuccessScreen.routeName,
            arguments: AlternateAuthSuccessScreen(
              provider: "Google",
            ),
          );
        }
      } catch (e) {
        yield AuthInitialInitial();
      }
      yield AuthInitialInitial();
    }

    if (event is ForgotPasswordEvent) {
      Navigator.pushNamed(context, ForgotPasswordScreen.routeName,
          arguments: ForgotPasswordScreen());
    }
    if (event is LogInByEmail) {
      try {
        String response = await use
            .get<AuthenticationService>()
            .logInUser(event.email, event.pass);
        if (response == "PHONE_NOT_REGISTERED_ERROR") {
          Navigator.pushNamed(
            context,
            AlternateAuthSuccessScreen.routeName,
            arguments: AlternateAuthSuccessScreen(
              provider: "Email",
            ),
          );
        } else if (response != "success") {
          ErrorDialog.showErrorDialog(context, error: response);
        } else {
          await use
              .get<AuthenticationService>()
              .logUserIntoApp(context, newAccount: false);
        }
      } catch (e) {
        yield AuthInitialInitial();
      }
      yield AuthInitialInitial();
    }
    if (event is SignUpByEmail) {
      try {
        String emailResponse = await use
            .get<AuthenticationService>()
            .checkIfEmailExists(event.email);
        if (emailResponse != "success") {
          ErrorDialog.showErrorDialog(context,
              error: "The email is already in use");
        } else {
          Map<String, dynamic> phoneExists = await use
              .get<AuthenticationService>()
              .checkIfPhoneExists(event.phone);
          //If there's some email which is added with this phone
          // if (response.isNotEmpty && response != event.email) {
          print('Phone Exists: $phoneExists');
          if (phoneExists['exists'] && phoneExists['email'] != event.email) {
            ErrorDialog.showErrorDialog(context,
                error:
                    "This mobile number is already in use by another email address.");
          } else {
            await _verifyPhoneNumber(event.phone, event.name, event.email);
          }
        }
      } catch (e) {
        ErrorDialog.showErrorDialog(context,
            error: "Oops! Couldn't verify your mobile number.");
      }
      yield AuthInitialInitial();
    }
    if (event is AuthInitialVerificationComplete) {
      try {
        UserCredential userCredentials =
            await FirebaseAuth.instance.signInWithCredential(event.credential);
        if (userCredentials.user != null) {
          use.get<UserService>().setUser(userCredentials.user);
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            CreatePasswordScreen.routeName,
            arguments: CreatePasswordScreen(
              name: event.name,
              email: event.email,
            ),
          );
        }
      } catch (e) {
        yield AuthInitialInitial();
      }
      yield AuthInitialInitial();
    }
    if (event is AuthInitialVerificationFailed) {
      yield AuthInitialInitial();
      ErrorDialog.showErrorDialog(context, error: event.exception.message);
    }
    if (event is AuthInitialCodeSent) {
      Navigator.pushNamed(
        context,
        OTPVerificationScreen.routeName,
        arguments: OTPVerificationScreen(
            fromAlternateProvider: false,
            phoneNo: event.phone,
            email: event.email,
            name: event.name,
            verificationId: event.verificationId,
            forceResendToken: event.forceResendToken),
      );
      yield AuthInitialInitial();
    }
  }

  Future<void> _verifyPhoneNumber(
      String phoneNumber, String name, String email) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential credential) {
          add(AuthInitialVerificationComplete(credential, email, name));
        },
        verificationFailed: (FirebaseAuthException authException) {
          add(AuthInitialVerificationFailed(authException));
        },
        codeSent: (String verificationId, [int forceResendToken]) {
          add(AuthInitialCodeSent(
              verificationId, phoneNumber, email, name, forceResendToken));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print(e.toString());
      ErrorDialog.showErrorDialog(context,
          error: "There seems an error during mobile verification.");
    }
  }
}
