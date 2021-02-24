import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:museumora/widgets/loading_indicator.dart';

import 'bloc/otp_verification_bloc/otp_verification_bloc.dart';

class OTPVerificationScreen extends StatefulWidget {
  static const routeName = '/otpVerificationScreen';

  final bool fromAlternateProvider;
  final String phoneNo;
  final String verificationId;
  final String email;
  final String name;
  final int forceResendToken;

  const OTPVerificationScreen({
    Key key,
    @required this.fromAlternateProvider,
    @required this.phoneNo,
    @required this.verificationId,
    @required this.forceResendToken,
    this.email,
    this.name,
  }) : super(key: key);
  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with SingleTickerProviderStateMixin {
  final int waitingTime = 30;
  int remainingTime = 30;
  Size _screenSize;
  int _currentDigit,
      _firstDigit,
      _secondDigit,
      _thirdDigit,
      _fourthDigit,
      _fifthDigit,
      _sixthDigit;

  Timer _timer;
  bool _enableResendButton;
  bool activeButton = false;

  OtpVerificationBloc otpVerificationBloc;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    otpVerificationBloc.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    // widget.authBloc.context = context;
    return Scaffold(
        body: BlocProvider<OtpVerificationBloc>(
      create: (context) {
        otpVerificationBloc = OtpVerificationBloc(
          context,
          phoneNumber: widget.phoneNo,
          fromAlternateProvider: widget.fromAlternateProvider,
          verificationId: widget.verificationId,
          forceResendToken: widget.forceResendToken,
          name: widget.name,
          email: widget.email,
        );
        return otpVerificationBloc;
      },
      child: BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
        builder: (context, state) {
          return Container(
            height: _screenSize.height,
            width: _screenSize.width,
            decoration: BoxDecoration(
              color: Colors
                  .white, /*gradient: LinearGradient(
                  colors: [Color(0xFF0C7FF2), Color(0xFF0057AD)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),*/
            ),
            child: LoadingIndicator(
              showProgress: state is OTPVerificationLoading,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 36 + MediaQuery.of(context).padding.top),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Verification Code',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0057AD)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Please Enter the 6-digit code sent to you at ${widget.phoneNo}',
                 
                    ),
                  ),
                  _getInputField,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      _enableResendButton
                          ? 'Tap on resend OTP button if not yet recieved'
                          : 'If you dont recieve the code in $remainingTime seconds tap below to resend it',
                      textAlign: TextAlign.center,
          
                    ),
                  ),
                  _getResendButton,
                  _getOtpKeyboard,
                ],
              ),
            ),
          );
        },
      ),
    ));
  }

  // Return "OTP" input field
  get _getInputField {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
        _otpTextField(_fifthDigit),
        _otpTextField(_sixthDigit),
      ],
    );
  }

  // Returns "Resend" button
  get _getResendButton {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: RaisedButton(
        color: Color(0xFF0057AD),
        disabledTextColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Text(
            "RESEND OTP" + (_enableResendButton ? "" : " ( $remainingTime ) "),
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),
          ),
        ),
        onPressed: !_enableResendButton
            ? null
            : () {
                otpVerificationBloc.add(ResendOtp());
                _startTimer();
              },
      ),
    );
  }

  // Returns "Otp" keyboard
  get _getOtpKeyboard {
    Radius radius = Radius.circular(24);
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,

              offset: Offset(1.0, 0.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        height: _screenSize.height * .3 + 15,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "1",
                      onPressed: () {
                        _setCurrentDigit(1);
                      }),
                  _otpKeyboardInputButton(
                      label: "2",
                      onPressed: () {
                        _setCurrentDigit(2);
                      }),
                  _otpKeyboardInputButton(
                      label: "3",
                      onPressed: () {
                        _setCurrentDigit(3);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "4",
                      onPressed: () {
                        _setCurrentDigit(4);
                      }),
                  _otpKeyboardInputButton(
                      label: "5",
                      onPressed: () {
                        _setCurrentDigit(5);
                      }),
                  _otpKeyboardInputButton(
                      label: "6",
                      onPressed: () {
                        _setCurrentDigit(6);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "7",
                      onPressed: () {
                        _setCurrentDigit(7);
                      }),
                  _otpKeyboardInputButton(
                      label: "8",
                      onPressed: () {
                        _setCurrentDigit(8);
                      }),
                  _otpKeyboardInputButton(
                      label: "9",
                      onPressed: () {
                        _setCurrentDigit(9);
                      }),
                ],
              ),
            ),
            Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new SizedBox(
                    width: 80.0,
                  ),
                  _otpKeyboardInputButton(
                      label: "0",
                      onPressed: () {
                        _setCurrentDigit(0);
                      }),
                  _otpKeyboardActionButton(
                      label: new Icon(
                        Icons.backspace,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_sixthDigit != null) {
                            _sixthDigit = null;
                          } else if (_fifthDigit != null) {
                            _fifthDigit = null;
                          } else if (_fourthDigit != null) {
                            _fourthDigit = null;
                          } else if (_thirdDigit != null) {
                            _thirdDigit = null;
                          } else if (_secondDigit != null) {
                            _secondDigit = null;
                          } else if (_firstDigit != null) {
                            _firstDigit = null;
                          }
                        });
                      }),
                ],
              ),
            ),
          ],
        ));
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int digit) {
    return new Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: new Text(
        digit != null ? digit.toString() : "",
        style: new TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 2.0,
        color: (digit != null ? Color(0xff0057AD) : Colors.grey),
      ))),
    );
  }

  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(40.0),
        child: new Container(
          width: 80,
          height: 80,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: new Center(
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return new InkWell(
      onTap: onPressed,
      borderRadius: new BorderRadius.circular(40.0),
      child: new Container(
        height: 80.0,
        width: 80.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: label,
        ),
      ),
    );
  }

  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;
      } else if (_fifthDigit == null) {
        _fifthDigit = _currentDigit;
      } else if (_sixthDigit == null) {
        _sixthDigit = _currentDigit;

        var otp = _firstDigit.toString() +
            _secondDigit.toString() +
            _thirdDigit.toString() +
            _fourthDigit.toString() +
            _fifthDigit.toString() +
            _sixthDigit.toString();

        otpVerificationBloc.add(OtpEnteredEvent(otp));
      }
    });
  }

  void clearOtp() {
    _sixthDigit = null;
    _fifthDigit = null;
    _fourthDigit = null;
    _thirdDigit = null;
    _secondDigit = null;
    _firstDigit = null;
    setState(() {});
  }

  void _startTimer() async {
    setState(() {
      _enableResendButton = false;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick == waitingTime) {
        _enableResendButton = true;
        _timer.cancel();
      }
      setState(() {
        remainingTime = waitingTime - timer.tick;
      });
    });
  }
}
