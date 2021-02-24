import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:museumora/widgets/loading_indicator.dart';

import 'bloc/alternate_success_mobile_bloc/alternate_success_bloc.dart';

class AlternateAuthSuccessScreen extends StatefulWidget {
  static const routeName = '/alternateAuthSuccessScreen';
  final String provider;

  const AlternateAuthSuccessScreen({Key key, this.provider}) : super(key: key);

  @override
  _AlternateAuthSuccessScreenState createState() =>
      _AlternateAuthSuccessScreenState();
}

class _AlternateAuthSuccessScreenState
    extends State<AlternateAuthSuccessScreen> {
  String _phone, _phoneCode;
  GlobalKey<FormState> _formKey;
  bool activeButton = false;

  @override
  void initState() {
    super.initState();
    _phoneCode = "+91";
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => AlternateSuccessBloc(context),
        child: BlocBuilder<AlternateSuccessBloc, AlternateSuccessState>(
          builder: (context, state) {
            return Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: LoadingIndicator(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(height: 37 + MediaQuery.of(context).padding.top),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Signed Up with ${widget.provider}!',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Please enter your preferred mobile number for your account.',
                      ),
                      SizedBox(height: 53),
                      Form(
                        onChanged: () {
                          setState(() {
                            activeButton = true;
                          });
                        },
                        key: _formKey,
                        child: Column(
                          children: [
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
                                      labelText: 'Mobile Number/Email',
                                      labelStyle: TextStyle(
                                          color: Color(0xff7E7E7E),
                                          fontSize: 13),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff7E7E7E))),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFF0057AD))),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return 'Please fill this field';
                                      return null;
                                    },
                                    onSaved: (val) {
                                      _phone = val.trim();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            // TextFormField(
                            //   keyboardType: TextInputType.phone,
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //   ),
                            //   cursorColor: Colors.black,
                            //   decoration: InputDecoration(
                            //     prefixText: '+91 ',
                            //     prefixStyle: TextStyle(
                            //         color: Colors.black, fontSize: 13),
                            //     labelText: 'Mobile number',
                            //     labelStyle: TextStyle(
                            //         color: Colors.black, fontSize: 13),
                            //     enabledBorder: UnderlineInputBorder(
                            //         borderSide: BorderSide(color: Colors.grey)),
                            //     focusedBorder: UnderlineInputBorder(
                            //         borderSide:
                            //             BorderSide(color: Color(0xFF0057AD))),
                            //   ),
                            //   validator: (value) {
                            //     if (value.isEmpty)
                            //       return 'Enter your mobile number';
                            //     if (value.trim().length != 10)
                            //       return 'Enter 10 digit number';
                            //     return null;
                            //   },
                            //   onSaved: (val) {
                            //     _phone = '+91' + val;
                            //   },
                            // ),
                            SizedBox(height: 32),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: RaisedButton(
                                color: (activeButton == false
                                    ? Colors.grey[400]
                                    : Color(0xFF0C7FF2)),
                                disabledTextColor: Colors.white,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  alignment: Alignment.center,
                                  child: Text(
                                    state is AlternateSuccessLoading
                                        ? "Loading..."
                                        : "CONTINUE",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 16),
                                  ),
                                ),
                                onPressed: () {
                                  _formKey.currentState.save();
                                  if (_formKey.currentState.validate()) {
                                    // print(_phoneCode + _phone);
                                    FocusScope.of(context).unfocus();
                                    BlocProvider.of<AlternateSuccessBloc>(
                                            context)
                                        .add(
                                            AddPhoneEvent(_phoneCode + _phone));
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                showProgress: state is AlternateSuccessLoading,
              ),
            );
          },
        ),
      ),
    );
  }
}
