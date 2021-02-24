import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:museumora/widgets/loading_indicator.dart';

import 'bloc/create_password_bloc/create_password_bloc.dart';

class CreatePasswordScreen extends StatefulWidget {
  static const routeName = '/createPasswordScreen';
  final String name, email;
  CreatePasswordScreen({
    Key key,
    @required this.name,
    @required this.email,
  }) : super(key: key);
  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  Size _screenSize;
  String _password;
  GlobalKey<FormState> _formKey;
  bool passwordObscure = true, confirmPassObscure = true, activeButton = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            CreatePasswordBloc(context, widget.name, widget.email),
        child: Container(
          height: _screenSize.height,
          width: _screenSize.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: BlocBuilder<CreatePasswordBloc, CreatePasswordState>(
            builder: (context, state) {
              return LoadingIndicator(
                showProgress: state is CreatePasswordLoading,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 36 + MediaQuery.of(context).padding.top),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create a password',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Please create a strong password with atleast 8 character and 1 number',
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
                              obscureText: passwordObscure,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 13),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff7E7E7E))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF0057AD))),
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
                                            child: Icon(
                                                Icons.remove_red_eye_outlined))
                                        : Transform.scale(
                                            scale: 0.5,
                                            child: Icon(Icons.remove_red_eye)),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please fill this field';
                                if (!matchesCriteria(value))
                                  return '(Use atleast 1 special character and 1 number)';

                                return null;
                              },
                              onSaved: (val) {
                                _password = val;
                              },
                            ),
                            SizedBox(height: 24),
                            TextFormField(
                              obscureText: confirmPassObscure,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 13),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff7E7E7E))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF0057AD))),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      confirmPassObscure = !confirmPassObscure;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 15.0),
                                    child: confirmPassObscure
                                        ? Transform.scale(
                                            scale: 0.5,
                                            child: Icon(
                                                Icons.remove_red_eye_outlined))
                                        : Transform.scale(
                                            scale: 0.5,
                                            child: Icon(Icons.remove_red_eye)),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please fill this field';
                                if (value != _password)
                                  return 'Passwords does not match';

                                return null;
                              },
                              onSaved: (newValue) {},
                            ),
                            SizedBox(height: 80),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: RaisedButton(
                                color: (activeButton ==
                                        false //_formKey.currentState == null
                                    ? Colors.grey[400]
                                    : Color(0xFF0C7FF2)),
                                disabledTextColor: Colors.white,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  alignment: Alignment.center,
                                  child: Text(
                                    state is CreatePasswordLoading
                                        ? "Getting things ready..."
                                        : "START THE JOURNEY",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 16),
                                  ),
                                ),
                                onPressed: () {
                                  _formKey.currentState.save();
                                  if (_formKey.currentState.validate()) {
                                    FocusScope.of(context).unfocus();
                                    BlocProvider.of<CreatePasswordBloc>(context)
                                        .add(AddPasswordToUser(_password));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  bool matchesCriteria(String value) {
    if (value.length < 8) return false;
    RegExp regX = new RegExp('(?=.*[0-9])');
    return regX.hasMatch(value);
  }
}
