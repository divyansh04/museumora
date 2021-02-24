import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:museumora/widgets/loading_indicator.dart';

import 'bloc/forgot_password_bloc/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgotPasswordScreen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _email;
  GlobalKey<FormState> _formKey;
  bool activeButton = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocProvider(
        create: (context) => ForgotPasswordBloc(context),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            height: _screenSize.height,
            width: _screenSize.width,
            child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
              builder: (context, state) {
                return LoadingIndicator(
                  showProgress: state is ForgotPasswordLoading,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(
                            height: 36 + MediaQuery.of(context).padding.top),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Reset your password',
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 24),
                        Form(
                          onChanged: () {
                            setState(() {
                              activeButton = true;
                            });
                          },
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  labelText: 'Email address',
                                  hintText: 'Enter your Email address',
                                  labelStyle: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF0057AD))),
                                ),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Email can not be empty';
                                  return null;
                                },
                                onSaved: (val) {
                                  _email = val;
                                },
                              ),
                              SizedBox(height: 80),
                              _createPasswordButton
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }

  get _createPasswordButton {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: RaisedButton(
        color: (activeButton == false ? Colors.grey[400] : Color(0xFF0C7FF2)),
        disabledTextColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Text(
            "Reset Password",
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),
          ),
        ),
        onPressed: () async {
          FocusScope.of(context).unfocus();
          _formKey.currentState.save();
          if (_formKey.currentState.validate()) {
            // FirebaseAuth.instance.confirmPasswordReset(oobCode, newPassword)
            makeProgressDialog();
            String errorMessage;
            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
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
            hideDialog();
            await Future.delayed(Duration(milliseconds: 60));
            if (errorMessage != null) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(errorMessage),
                duration: Duration(seconds: 5),
              ));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Password Reset mail succesfully sent'),
              ));
              await Future.delayed(Duration(seconds: 4));
              Navigator.of(context).pop();
            }
          }
        },
      ),
    );
  }

  hideDialog() {
    Navigator.of(context).pop();
  }

  makeProgressDialog() {
    showDialog(
        context: this.context,
        barrierDismissible: false,
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ));
  }
}
