import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:museumora/screens/signIn/bloc/auth_initial/auth_initial_bloc.dart';

import '../auth_initial_screen.dart';
import '../forgot_password_screen.dart';
import '../signup_screen.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey;
  String _email, _password; //, _phoneCode;

  bool passwordObscure = true;
  bool activeButton = false;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    // _phoneCode = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width;
    return Container(
      width: sWidth,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: BlocBuilder<AuthInitialBloc, AuthInitialState>(
          builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 16.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFF0057AD),
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ),
            Form(
              onChanged: () {
                setState(() {
                  activeButton = true;
                });
              },
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number/Email',
                        labelStyle:
                            TextStyle(color: Color(0xff7E7E7E), fontSize: 13),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff7E7E7E))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF0057AD))),
                      ),
                      validator: (value) {
                        if (value.isEmpty) return 'Please fill this field';
                        return null;
                      },
                      onSaved: (val) {
                        _email = val;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      obscureText: passwordObscure,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: Color(0xff7E7E7E), fontSize: 13),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff7E7E7E))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF0057AD))),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              passwordObscure = !passwordObscure;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: passwordObscure
                                ? Transform.scale(
                                    scale: 0.5,
                                    child: Icon(Icons.remove_red_eye_outlined))
                                : Transform.scale(
                                    scale: 0.5,
                                    child: Icon(Icons.remove_red_eye)),
                          ),
                        ),
                      ),
                      validator: (password) {
                        if (password.isEmpty) return 'Please fill this field';
                        return null;
                      },
                      onSaved: (val) {
                        _password = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ForgotPasswordScreen.routeName,
                      arguments: ForgotPasswordScreen());
                },
                child: Text(
                  'Forgot Password ?',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0057AD)),
                ),
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),

                color: (activeButton == false //_formKey.currentState == null
                    ? Color(0xffB8B6B6)
                    : Color(0xFF0C7FF2)), //Colors.white,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    FocusScope.of(context).unfocus();
                    BlocProvider.of<AuthInitialBloc>(context)
                        .add(LogInByEmail(_email.trim(), _password.trim()));
                  }
                },
                child: Container(
                  width: sWidth - 2 * 36,
                  padding: const EdgeInsets.all(12.0),
                  child: (state is AuthInitialLoading)
                      ? Center(
                          child: Text('LOADING...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white)),
                        )
                      : Center(
                          child: Text('CONTINUE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white)),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: 'New to app? ',
                      style: TextStyle(color: Colors.grey)),
                  TextSpan(
                    text: 'SIGN UP',
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Color(0xFF0057AD),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushReplacementNamed(
                            SignupScreen.routeName,
                            arguments: SignupScreen());
                      },
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 2,
                    width: sWidth / 2 - 60,
                    color: Colors.grey[200],
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'OR',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.grey),
                  ),
                  SizedBox(width: 15.0),
                  Container(
                    height: 2,
                    width: sWidth / 2 - 60,
                    color: Colors.grey[200],
                  )
                ],
              ),
            ),
            AlternateProviders(
              isSignInScreen: true,
            ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  GlobalKey<FormState> _formKey;
  String _name, _email, _phone, _phoneCode;
  bool activeButton = false;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _phoneCode = '+91';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<AuthInitialBloc, AuthInitialState>(
        builder: (context, state) {
      return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 16.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFF0057AD),
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ),
            Form(
              onChanged: () {
                setState(() {
                  activeButton = true;
                });
              },
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle:
                            TextStyle(color: Color(0xff7E7E7E), fontSize: 13),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff7E7E7E))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF0057AD))),
                      ),
                      validator: (value) {
                        if (value.isEmpty) return 'Please fill this field';
                        if (value.length < 3)
                          return 'Please enter the full name';
                        return null;
                      },
                      onSaved: (val) {
                        _name = val;
                      },
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Id',
                        labelStyle:
                            TextStyle(color: Color(0xff7E7E7E), fontSize: 13),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff7E7E7E))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF0057AD))),
                      ),
                      validator: (email) {
                        if (email.isEmpty) return 'Please fill this field';
                        if (!EmailValidator.validate(email))
                          return 'Incorrect Email entered.';
                        return null;
                      },
                      onSaved: (val) {
                        _email = val;
                      },
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            labelStyle: TextStyle(
                                color: Color(0xff7E7E7E), fontSize: 13),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff7E7E7E))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0057AD))),
                          ),
                          validator: (value) {
                            if (value.isEmpty) return 'Please fill this field';
                            return null;
                          },
                          onSaved: (val) {
                            _phone = val;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: (activeButton == false
                    ? Color(0xffB8B6B6)
                    : Color(0xFF0C7FF2)),
                onPressed: (state is AuthInitialLoading)
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          FocusScope.of(context).unfocus();
                          BlocProvider.of<AuthInitialBloc>(context)
                              .add(SignUpByEmail(
                            _name.trim(),
                            _email.trim(),
                            _phoneCode + _phone.trim(),
                          ));
                        }
                      },
                child: Container(
                  width: sWidth - 2 * 36,
                  padding: const EdgeInsets.all(12.0),
                  child: (state is AuthInitialLoading)
                      ? Text('LOADING...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white))
                      : Text('CONTINUE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.grey)),
                  TextSpan(
                    text: 'LOGIN',
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Color(0xFF0057AD),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushReplacementNamed(
                            AuthInitialScreen.routeName,
                            arguments: AuthInitialScreen());
                      },
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 2,
                    width: sWidth / 2 - 60,
                    color: Colors.grey[200],
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'OR',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Container(
                    height: 2,
                    width: sWidth / 2 - 60,
                    color: Colors.grey[200],
                  )
                ],
              ),
            ),
            AlternateProviders(
              isSignInScreen: false,
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

//Shows at the bottom of the SignIn and SignUp screen
class AlternateProviders extends StatelessWidget {
  final bool isSignInScreen;

  const AlternateProviders({Key key, @required this.isSignInScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String prefix = 'Continue with';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FlatButton(
            onPressed: () {
              BlocProvider.of<AuthInitialBloc>(context)
                  .add(GoogleSignInEvent());
            },
            padding: EdgeInsets.all(12),
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: Color(0xffC8C7CC))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.grid_on),
                SizedBox(width: 15.0),
                Text(
                  '$prefix Google',
                ),
              ],
            ),
          ),
        ),
        // SizedBox(height: 12),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: FlatButton(
        //     onPressed: () {
        //       BlocProvider.of<AuthInitialBloc>(context)
        //           .add(FacebookSignInEvent());
        //     },
        //     padding: EdgeInsets.all(12),
        //     color: Colors.transparent,
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(4.0),
        //         side: BorderSide(color: Color(0xffC8C7CC))),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         SvgPicture.asset(
        //           'assets/images/facebook.svg',
        //         ),
        //         SizedBox(width: 15.0),
        //         Text(
        //           '$prefix Facebook',
        //           style: commonTitle1Theme,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
