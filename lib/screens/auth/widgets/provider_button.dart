import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:museumora/screens/auth/auth_service.dart';
import 'package:museumora/screens/dashboard/dashboard.dart';

class ProviderButton extends StatefulWidget {
  final BuildContext context;
  final String signInType;

  const ProviderButton({Key key, this.context, this.signInType})
      : super(key: key);

  @override
  _ProviderButtonState createState() => _ProviderButtonState();
}

class _ProviderButtonState extends State<ProviderButton> {
  AuthMethods _authMethods=AuthMethods();
  @override
  Widget build(BuildContext context) {
    switch (widget.signInType) {
      case "google":
        return InkWell(
          onTap: (){
            performGoogleLogin();
          },
          // onTap: () => context.signInWithGoogle(),
          child: Container(
              padding: const EdgeInsets.all(12.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black26,
                ),
              ),
              child:Image.asset('assets/images/google.png',height: 25,)),
        );
      default:
        return const Text("error");
    }
  }
  void performGoogleLogin() async {
    UserCredential user = await _authMethods.signInWithGoogle();
    if (user != null) {
      authenticateUser(user.user);
    }
  }

  void authenticateUser(User user) {
    _authMethods.authenticateUser(user).then((isNewUser) {
      if (isNewUser) {
        _authMethods.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
                return Dashboard();
              }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return Dashboard();
            }));
      }
    });
  }
}
