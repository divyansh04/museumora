import 'package:flutter/material.dart';

import 'package:museumora/screens/dashboard/dashboard.dart';

import 'auth/auth.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  static MaterialPageRoute get route => MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );

  @override
  Widget build(BuildContext context) {

    // #TODO: loading indicator was initialized here

    // final user = context.watchSignedInUser();
    // user.map(
    //   (value) {
    //     _navigateToHomeScreen(context);
    //   },
    //   empty: (_) {
    //     _navigateToAuthScreen(context);
    //   },
    //   initializing: (_) {},
    // );

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _navigateToAuthScreen(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Navigator.of(context).pushReplacement(AuthScreen.route),
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Navigator.of(context).pushReplacement(Dashboard.route),
    );
  }
}
