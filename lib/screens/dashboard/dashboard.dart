import 'package:flutter/material.dart';
import 'package:museumora/screens/SignIn/auth_initial_screen.dart';
import 'package:museumora/services/moduleServices/userServices.dart';
import 'package:museumora/services/serviceLocator.dart';

class Dashboard extends StatelessWidget {
  static const routeName = 'dashboard';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('I\'m in'),
              Container(
                height: 50.0,
                width: 100.0,
                color: Colors.amber,
                child: FlatButton(
                  onPressed: () async {
                    // logout user
                    await use.get<UserService>().logoutUser();
                    // Navigating back to SignIn screen
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.of(context).pushReplacementNamed(
                        AuthInitialScreen.routeName,
                        arguments: AuthInitialScreen());
                  },
                  child: Text('Logout'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
