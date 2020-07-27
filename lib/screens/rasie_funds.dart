import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:maverick_red_2245/authentication_service.dart';
import 'package:maverick_red_2245/screens/navbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Funds extends StatefulWidget {
  @override
  _FundsState createState() => _FundsState();
}

class _FundsState extends State<Funds> {
  Auth _auth = Auth();
  Razorpay _razorpay;

  final _formkey = GlobalKey<FormState>();
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  TextEditingController _fund = TextEditingController();
  String name = " ";
  String ph = " ";
  String aadhar = " ";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tap();

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  tap() async {
    var user = await _auth.getCurrentUser();

    dbref.child(user.uid.toString()).once().then((DataSnapshot data) {
      try {
        print(data.value['name']);
        setState(() {
          name = data.value['name'];
          ph = data.value['ph'];
          aadhar = data.value['aadharid'];
        });
      } catch (e) {
        print("came to catch");
        setState(() {
          name = " ";
          ph = " ";
          aadhar = " ";
        });
      }
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_Nb25lBivYkrV81',
      'amount':
          num.parse(_fund.text) * 100, //in the smallest currency sub-unit.

      // Generate order_id using Orders API
      'description': "Donation for COVID 19 Relief Fund",
      'prefill': {'contact': '9123456789', 'email': 'gaurav.kumar@example.com'},
      'external': {
        'wallets': ['paytm']
      },
    };
    try {
      _razorpay.open(options);
    } catch (ex) {
      print(ex.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // ignore: unnecessary_statements
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success!"),
        content: Text(
            "Transaction is successfully done!\nPayment Id : ${response.paymentId}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Failed!"),
        content:
            Text("Transaction has failed!\n Message  : ${response.message}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response.walletName);
    // Do something when an external wallet is selected
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error!"),
        content: Text("Error at ${response.walletName}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AppBar(
                  backgroundColor: Colors.blue[800],
                  title: new Text("Covid 19 Tracking App",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w900)),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          FontAwesome.user_circle_o,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          name != " "
                              ? showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Center(
                                      child: Text("Personal Details"),
                                    ),
                                    content: Container(
                                      height: 75.0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Name : ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Text(
                                                "$name",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Ph : ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Text(
                                                ph,
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Aadhar Id : ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Text(
                                                aadhar,
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Text("No content"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                        }),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.1,
                          0.5,
                          1
                        ],
                        colors: [
                          Colors.blue[800],
                          Colors.blue,
                          Colors.lightBlue[100]
                        ]),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/givemoney.png",
                        scale: 6.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Covid 19 Relief",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                          Text(
                            "Funds",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 12.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15.0, // soften the shadow
                        spreadRadius: 5.0, //extend the shadow
                        offset: Offset(
                          10.0, // Move to right 10  horizontally
                          10.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 8.0, bottom: 8.0),
                        child: TextField(
                          controller: _fund,
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesome.money),
                            hintText: "Enter the donation amount ",
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: RaisedButton(
                            onPressed: () {
                              openCheckout();
                            },
                            child: Text("Donate"),
                            color: Colors.blue,
                            textColor: Colors.white,
                            splashColor: Colors.green,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class t {}
