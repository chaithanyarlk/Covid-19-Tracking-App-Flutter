import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:maverick_red_2245/authentication_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:maverick_red_2245/screens/navbar.dart';

import 'package:string_validator/string_validator.dart';

class Display extends StatefulWidget {
  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  Auth _auth = Auth();
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  TextEditingController temp = TextEditingController();
  String _barcode = "Generate QR code to display ";
  String _name = " ";
  String _ph = " ";
  String _aadhar = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    details();
    tap();
  }
  tap() async {
    var user = await _auth.getCurrentUser();

    dbref.child(user.uid.toString()).once().then((DataSnapshot data) {
      try {
        print(data.value['name']);
        setState(() {
          _name = data.value['name'];
          _ph = data.value['ph'];
          _aadhar = data.value['aadharid'];
        });
      } catch (e) {
        print("came to catch");
        setState(() {
          _name = " ";
          _ph = " ";
          _aadhar = " ";
        });
      }
    });
  }

  @override
  void dispose() {
    temp.dispose();
    super.dispose();
  }

  Future<String> details() async {
    var user = await _auth.getCurrentUser();
    dbref.child(user.uid.toString()).once().then((DataSnapshot data) {
      print("came");
      try {
        print(data.value['ph']);

        String name = data.value['name'];
        String aadharid = data.value['aadharid'];
        String ph = data.value['ph'];
        String body = data.value['Body Temperature'];
        String cold = data.value['Cold'];
        String sore = data.value['Sore Throat'];
        String tire = data.value['Tiredness'];
        String breath = data.value['Breathing Problem'];
        String last = data.value['Recorded On'];
        print(name + aadharid + ph + body);
        setState(() {
          _barcode = "Name : " +
              name +
              "\nAadhar Id : " +
              aadharid +
              "\nph : " +
              ph +
              "\nBody Temperature : " +
              body +
              "\nCold : " +
              cold +
              "\nSore Throat : " +
              sore +
              "\nTiredness : " +
              tire +
              "\nBreathing Problem : " +
              breath +
              "\nRecorded On : " +
              last;
        });
        print(_barcode);

        /*_barcode = "Name : " +
          data.value['name'] +
          "\n" +
          "Aadhar Id : " +
          data.value['aadharid'] +
          "\n" +
          "Phone : " +
          data.value['ph'] +
          "\n" +
          "Body Temperature : " +
          data.value['BodyTemperature'] +
          "\n" +
          "Cold : " +
          data.value['Cold'];*/
        print(_barcode);
      } catch (e) {
        setState(() {
          _barcode = "Error in fetching data";
        });
      }
      return (_barcode);
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = _auth.getCurrentUser();

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
                          _name != " "
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
                                                "$_name",
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
                                                _ph,
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
                                                _aadhar,
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
                        "assets/images/croods.png",
                        scale: 2.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Generate your",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                          Text(
                            "QR Code",
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "This Qr Code need to be scanned by persons whom you are meeting.This can be used to track down a person's details and health status instantly to prevent threat of spread of virus in public places",
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 15.0),
                        ),
                        
                        Center(
                          child: QrImage(
                            data: _barcode.toString(),
                            version: QrVersions.auto,
                            size: 200.0,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 12,
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
