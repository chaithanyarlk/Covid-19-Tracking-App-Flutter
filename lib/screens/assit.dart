import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:maverick_red_2245/authentication_service.dart';
import 'package:maverick_red_2245/models/cases.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maverick_red_2245/screens/navbar.dart';
import 'package:string_validator/string_validator.dart';

class Assit extends StatefulWidget {
  @override
  _AssitState createState() => _AssitState();
}

class _AssitState extends State<Assit> {
  Auth _auth = Auth();
  String name = " ";
  String ph = " ";
  String aadhar = " ";
  final _formkey = GlobalKey<FormState>();
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  TextEditingController temp = TextEditingController();
  var _cold = "Select an Option";
  var _breathing = "Select an Option";
  var _soar = "Select an Option";
  var _tiredness = "Select an Option";
  var _test = "Select an Option";
  var _fever = "Select an Option";
  List<String> options = <String>["Yes", "No"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tap();
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
    temp.dispose();
    super.dispose();
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
                        "assets/images/doc.png",
                        scale: 6.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Take a Quick",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                          Text(
                            "Survey ...",
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
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Please answer the below with poper answers to assit your health condition and to help us trace the contact persons by assessing your health condition.This data will be kept confidential and will be used for assessment",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Cold :",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                              SizedBox(
                                height: 30.0,
                                child: new DropdownButton<String>(
                                  hint: Text(_cold),
                                  items:
                                      <String>['Yes', 'No'].map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _cold = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Sore Throat :",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                              SizedBox(
                                height: 30.0,
                                child: new DropdownButton<String>(
                                  hint: Text(_soar),
                                  items:
                                      <String>['Yes', 'No'].map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _soar = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Breathing Problem :",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                              SizedBox(
                                height: 30.0,
                                child: new DropdownButton<String>(
                                  hint: Text(_breathing),
                                  items:
                                      <String>['Yes', 'No'].map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _breathing = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Tiredness :",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                              SizedBox(
                                height: 30.0,
                                child: new DropdownButton<String>(
                                  hint: Text(_tiredness),
                                  items:
                                      <String>['Yes', 'No'].map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _tiredness = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: TextFormField(
                            onChanged: (value) {
                              print(value);
                            },
                            keyboardType: TextInputType.number,
                            controller: temp,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                FontAwesome.thermometer_half,
                              ),
                              hintText:
                                  "Body temperature in Farenheit like '98.6'",
                            ),
                            validator: (val) {
                              print(num.parse(val));
                              var temp = num.parse(val);
                              if (temp > 108 && temp < 90) {
                                return ("Please enter a proper value");
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: RaisedButton(
                              color: Colors.blue,
                              splashColor: Colors.green,
                              textColor: Colors.white,
                              onPressed: () async {
                                if (_formkey.currentState.validate()) {
                                  print("validated");
                                  if (_cold.toString() != "Select an Option" &&
                                      _soar.toString() != "Select an Option" &&
                                      _breathing != "Select an Option" &&
                                      _tiredness != "Select an Option") {
                                    try {
                                      var user = await _auth.getCurrentUser();
                                      String userId = user.uid;
                                      print(_cold);
                                      print(_soar);
                                      print(_breathing);
                                      print(_tiredness);
                                      dbref.child(userId.toString()).update({
                                        'Body Temperature': temp.text,
                                        'Cold': _cold,
                                        'Sore Throat': _soar,
                                        'Breathing Problem': _breathing,
                                        'Tiredness': _tiredness,
                                        'Recorded On':
                                            DateTime.now().toString(),
                                      });
                                    } catch (ex) {
                                      print(ex.toString());
                                    }

                                    return showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text("Updated"),
                                        content: Text(
                                            "Your details has been updated successfully!"),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("close"),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    print("internal");
                                    print(_cold);
                                    print(_soar);
                                    print(_breathing);
                                    print(_tiredness);
                                    return showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text("Incomplete details"),
                                        content: Text(
                                            "Please fill all the details in the survey to assist you on your health condition!"),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("close"),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                } else {
                                  return showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text("Incomplete details"),
                                      content: Text(
                                          "Please fill all the details in the survey to assist you on your health condition!"),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("close"),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Text("Submit"),
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
        ),
      ),
    );
  }
}
