import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:museumora/screens/auth/auth_service.dart';
import 'package:museumora/screens/dashboard/dashboard.dart';
import 'decoration_functions.dart';
import 'sign_in_up_bar.dart';
import 'title.dart';

class Register extends StatefulWidget {
  const Register({Key key, this.onSignInPressed}) : super(key: key);

  final VoidCallback onSignInPressed;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey =GlobalKey<FormState>();
  AuthMethods _authMethods=AuthMethods();
  String _email;
  String _password;
  bool loading=false;
  @override
  Widget build(BuildContext context) {

    // final isSubmitting = context.isSubmitting();

    return Form(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: LoginTitle(
                  title: 'Create\nAccount',
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        onChanged: (value){
                          _email =value;
                        },
                        // ignore: missing_return
                        validator:(value) {
                          if (!(value.contains("@")) && value.isNotEmpty) {
                            return 'please enter a valid email address';
                          }
                          if(value==null || value.isEmpty){
                            return 'please enter email address';
                          }
                            },
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          decoration: registerInputDecoration(hintText: 'Email')),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        onChanged: (value){
                          _password =value;
                        },
                        // ignore: missing_return
                        validator:(value) {
                          if (!(value.length > 5) && value.isNotEmpty) {
                            return 'Password should contain more than 5 characters';
                          }
                          if(value==null || value.isEmpty){
                            return 'please enter password';
                          }
                        },
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        decoration: registerInputDecoration(hintText: 'Password'),
                      ),
                    ),
                    SignUpBar(
                      label: 'Sign up',
                      isLoading: loading, //isSubmitting,
                      onPressed: () {
                        if(formKey.currentState.validate()){
                            performSignUp();
                        }
                        // context.registerWithEmailAndPassword();
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          widget.onSignInPressed?.call();
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void performSignUp() async {
    setState(() {
      loading=true;
    });
    try {
      UserCredential user = await _authMethods.signUp(_email, _password);
      setState(() {
        loading=false;
      });
      if (user.user != null) {
        authenticateUser(user.user);
      }
    }
    catch(e){
      print(e);
      setState(() {
        loading=false;
      });
    }
  }

  void authenticateUser(User user) {
    setState(() {
      loading=true;
    });
    _authMethods.authenticateUser(user).then((isNewUser) {
      if (isNewUser) {
        _authMethods.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
                return Dashboard();
              }));
        });
        setState(() {
          loading=false;
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return Dashboard();
            }));
        setState(() {
          loading=false;
        });
      }
    });
  }
}

