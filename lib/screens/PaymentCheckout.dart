import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:museumora/screens/dashboard/dashboard.dart';
import 'package:museumora/screens/virtual_tour/views/screens/floorplan_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

class PaymentCheckout extends StatefulWidget {
  final String name;
  final String details;
  final double amount;
  final String imageUrl;
  PaymentCheckout({this.name,this.details,this.amount,this.imageUrl});
  @override
  _PaymentCheckoutState createState() => _PaymentCheckoutState();
}

class _PaymentCheckoutState extends State<PaymentCheckout> {
  Razorpay _razorPay = Razorpay();
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
      'amount': widget.amount*100,
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black,
          ),
          onPressed: (){Navigator.pop(context);},
        ),
        centerTitle: true,
        title: Text(
          'Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body:Container(
          height:MediaQuery.of(context).size.height,
          width:MediaQuery.of(context).size.width,
            child: ListView(
            children:[
              Container(
                width:MediaQuery.of(context).size.width,
                height: 200,
                child: Carousel(
                  boxFit: BoxFit.cover,
                  dotBgColor: Colors.transparent,
                  images: [
                    Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ],
                  autoplayDuration: Duration(seconds: 6),
                  animationCurve: Curves.fastOutSlowIn,
                  animationDuration: Duration(milliseconds: 1000),
                  dotSize: 3.0,
                  dotIncreasedColor: Colors.black,
                  dotColor: Colors.black,
                  indicatorBgPadding: 8.0,
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:14.0,vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      flex:2,
                      child: Text(widget.name,style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 25
                      ),
                      softWrap: true,),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Column(
                          children: [
                            Icon(
                              Icons.play_circle_outline_rounded,
                              color: Color(0xFF162A49),
                              size: 30
                            ),
                            Text('virtual tour',style: TextStyle(fontSize: 10),)
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FloorPlanScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:14.0),
                child: Text(widget.details,style: TextStyle(
                    color: Colors.black,
                    fontSize: 15
                ),
                  softWrap: true,),
              ),
            ]
          ),
        ),
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
                    '₹${widget.amount}',
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