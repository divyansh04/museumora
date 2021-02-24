
import 'package:flutter/material.dart';
import 'package:museumora/screens/dashboard/dashboard.dart';
import 'package:museumora/screens/signIn/auth_initial_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Dashboard.routeName:
        // print('1 generateRoute ' + Dashboard.routeName);
        return MaterialPageRoute(builder: (_) => Dashboard());

      case AuthInitialScreen.routeName:
        return MaterialPageRoute(builder: (_) => AuthInitialScreen());

      // case OnBoardingScreen.routeName:
      //   // print('3 generateRoute ' + OnBoardingScreen.routeName);
      //   return MaterialPageRoute(builder: (_) => OnBoardingScreen());
    }
    // print('4 generateRoute ' + settings.name);
    return MaterialPageRoute(builder: (_) => settings.arguments as Widget);
  }
}
