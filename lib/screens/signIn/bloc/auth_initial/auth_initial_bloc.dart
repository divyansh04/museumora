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

import '../../create_password_screen.dart';
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
        }
        //If phone already exists, log in
        await use
            .get<AuthenticationService>()
            .logUserIntoApp(context, newAccount: false);
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
        if (response != "success") {
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
          try {
            AuthCredential credential;
            UserCredential userCredentials =
                await FirebaseAuth.instance.signInWithCredential(credential);
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
        }
      } catch (e) {
        ErrorDialog.showErrorDialog(context, error: "please try again.");
      }
      yield AuthInitialInitial();
    }
  }
}
