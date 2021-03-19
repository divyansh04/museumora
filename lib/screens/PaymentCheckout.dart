import 'package:flutter/material.dart';
import 'package:museumora/screens/dashboard/dashboard.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

class PaymentCheckout extends StatefulWidget {
  @override
  _PaymentCheckoutState createState() => _PaymentCheckoutState();
}

class _PaymentCheckoutState extends State<PaymentCheckout> {
  Razorpay _razorPay = Razorpay();
  double totalAmount=100;
  @override
  void initState() {
    super.initState();
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorPay.clear();
  }


  void openCheckout() async {
    var options = {
      'key': 'rzp_test_cdSYYam2Bf9NRS',
      'amount': totalAmount*100,
      'name': 'Museumora',
      'description': 'Test payment',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorPay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: Container(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    '₹$totalAmount',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('inclusive of all taxes',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.redAccent,
                      )),
                ),
              ),
              Expanded(
                flex: 3,
                child: MaterialButton(
                  height: 45.0,
                  elevation: 0.3,
                  onPressed: () {
                    openCheckout();
                  },
                  color: Colors.black,
                  child: Text(
                    'Pay',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: 'Success:' + response.paymentId,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
    setState(() {
      showAlertDialog(context);
    });
  }

  _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: 'External Wallet:' + response.walletName,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: 'Payment cancelled',
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  showAlertDialog(BuildContext context) {
    Widget continueButton = GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      },
      child: Card(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
    AlertDialog alert = AlertDialog(
      title: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Text("Reserved successfully")
            ],
          )),
      content: Container(
        height: 150,
        child: Column(
          children: [
            Text(
              'Your reservation has been placed successfully',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            continueButton
          ],
        ),
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(onWillPop: () {}, child: alert);
        });
  }
}