import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museumora/services/moduleServices/authentication_service.dart';
import 'package:museumora/services/serviceLocator.dart';
import 'package:museumora/widgets/error_dialog.dart';
part 'create_password_event.dart';
part 'create_password_state.dart';

class CreatePasswordBloc
    extends Bloc<CreatePasswordEvent, CreatePasswordState> {
  final BuildContext context;
  final String name;
  final String email;
  CreatePasswordBloc(this.context, this.name, this.email)
      : super(CreatePasswordInitial());

  @override
  Stream<CreatePasswordState> mapEventToState(
    CreatePasswordEvent event,
  ) async* {
    yield CreatePasswordLoading();
    if (event is AddPasswordToUser) {
      String response = await use
          .get<AuthenticationService>()
          .createPassword(name, email, event.password);
      if (response != "success") {
        ErrorDialog.showErrorDialog(context, error: response);
        yield CreatePasswordInitial();
      } else {
        await use.get<AuthenticationService>().logUserIntoApp(context);
      }
    }
  }
}
