import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:museumora/widgets/loading_indicator.dart';

import 'bloc/auth_initial/auth_initial_bloc.dart';
import 'widgets/auth_widgets.dart';

class SignupScreen extends StatelessWidget {
  static const routeName = '/signUpScreen';

  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;
    return BlocProvider<AuthInitialBloc>(
      create: (context) => AuthInitialBloc(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            height: sHeight,
            width: sWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              /*gradient: LinearGradient(
                  colors: [Color(0xFF0C7FF2), Color(0xFF0057AD)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),*/
            ),
            child: BlocBuilder<AuthInitialBloc, AuthInitialState>(
              builder: (context, state) {
                return LoadingIndicator(
                  showProgress: state is AuthInitialLoading,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Expanded(child: SignUpForm()),

                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
