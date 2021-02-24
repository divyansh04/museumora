import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museumora/widgets/error_dialog.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final BuildContext context;
  ForgotPasswordBloc(this.context) : super(ForgotPasswordInitial());

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    yield ForgotPasswordLoading();
    if (event is SendPasswordResetMailEvent) {
      String response = await sendResetEmail(event.email);
      if (response != "success") {
        ErrorDialog.showErrorDialog(context, error: response);
      } else {
        await Future.delayed(Duration(seconds: 4));
        Navigator.of(context).pop();
      }
    }
  }

  Future<String> sendResetEmail(String email) async {
    String errorMessage;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      errorMessage =
          'Oops!! Some error occurred. Are you sure you used Email-Password Sign In method??';
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          errorMessage = "Your email address appears to be malformed.";
          break;
        case 'ERROR_USER_NOT_FOUND':
          errorMessage = "No account exists with this email";
          break;
      }
    }
    await Future.delayed(Duration(milliseconds: 60));
    if (errorMessage != null) {
      return errorMessage;
    } else {
      return "success";
    }
  }
}
