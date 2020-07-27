import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:maverick_red_2245/authentication_service.dart';
import 'package:maverick_red_2245/models/cases.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maverick_red_2245/screens/navbar.dart';

Future<Cases> fetchCases() async {
  final response = await http.get("https://api.covid19india.org/data.json");
  if (response.statusCode == 200) {
    return Cases.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Auth _auth = Auth();
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  Future<Cases> futureCases;
  String name = " ";
  String ph = " ";
  String aadhar = " ";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCases = fetchCases();
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
  Widget build(BuildContext context) {
    Future<FirebaseUser> user = _auth.getCurrentUser();
    DatabaseReference dbref = FirebaseDatabase.instance.reference();
    print((dbref.child(user.toString())).toString());

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
                        "assets/images/girl-mask.png",
                        scale: 6.0,
                      ),
                      FutureBuilder<Cases>(
                        future: futureCases,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "India",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: new Wrap(
                                    direction: Axis.vertical,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(1.0),
                                        child: Text(
                                          "Total Confirmed",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Text(
                                          "Cases : ${snapshot.data.confirmed}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 3.0, bottom: 3.0),
                                        child: Text(
                                          "Last updated ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 3.0, bottom: 3.0),
                                        child: Text(
                                          "${snapshot.data.lastupdate}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error in loading data");
                          }
                          return Center(
                            child: SizedBox(
                              height: 25.0,
                              width: 25.0,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 12.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: FutureBuilder<Cases>(
                    future: futureCases,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                FontAwesome.hospital_o,
                                size: 25.0,
                                color: Colors.black,
                              ),
                              Center(
                                child: new Text(
                                  "Active Cases : ${snapshot.data.active}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8.0),
                          child: new Text("There is an Error in loading data"),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                Container(
                  height: 12.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: FutureBuilder<Cases>(
                    future: futureCases,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                FontAwesome.bar_chart,
                                size: 25.0,
                                color: Colors.green,
                              ),
                              Center(
                                child: new Text(
                                  "Recovered : ${snapshot.data.recovered}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8.0),
                          child: new Text("There is an Error in loading data"),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                Container(
                  height: 12.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: FutureBuilder<Cases>(
                    future: futureCases,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                FontAwesome.line_chart,
                                size: 25.0,
                                color: Colors.red,
                              ),
                              Center(
                                child: new Text(
                                  "Deaths : ${snapshot.data.deaths}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8.0),
                          child: new Text("There is an Error in loading data"),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                Container(
                  height: 12.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.1, 1.0],
                        colors: [Colors.red[300], Colors.white]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 25.0, // soften the shadow
                        spreadRadius: 5.0, //extend the shadow
                        offset: Offset(
                          15.0, // Move to right 10  horizontally
                          15.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Symptoms :",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800),
                      ),
                      Padding(
                        // cold
                        padding: EdgeInsets.all(8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                height: 80,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 80.0,
                                        width: 150.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                          boxShadow: [],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 80.0,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                        "assets/images/commoncold.png",
                                                      ),
                                                      fit: BoxFit.fill)),
                                            ),
                                            Center(
                                              child: Text("Cold",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 18.0)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 80.0,
                                        width: 280.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                          boxShadow: [],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 65.0,
                                              width: 65.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                        "assets/images/fever.png",
                                                      ),
                                                      fit: BoxFit.fill)),
                                            ),
                                            Center(
                                              child: Text(
                                                  "Fever/Fever with chills",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 18.0)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 80.0,
                                        width: 225.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                          boxShadow: [],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 65.0,
                                              width: 65.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                        "assets/images/cough.png",
                                                      ),
                                                      fit: BoxFit.fill)),
                                            ),
                                            Center(
                                              child: Text("Dry or Wet Cough",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 18.0)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 80.0,
                                        width: 200.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                          boxShadow: [],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 65.0,
                                              width: 65.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                        "assets/images/ore_throat.png",
                                                      ),
                                                      fit: BoxFit.fill)),
                                            ),
                                            Center(
                                              child: Text("Sore Throat",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 18.0)),
                                            ),
                                          ],
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
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    color: Colors.white,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.1, 1.0],
                        colors: [Colors.blue[300], Colors.white]),
                    boxShadow: [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Preventive Measures :",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800),
                      ),
                      Padding(
                        // cold
                        padding: EdgeInsets.all(8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                height: 80,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 80.0,
                                        width: 280.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                          boxShadow: [],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 80.0,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                        "assets/images/hand-washing.png",
                                                      ),
                                                      fit: BoxFit.fill)),
                                            ),
                                            Center(
                                              child: Text(
                                                  "Wash hands frequently",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 18.0)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 80.0,
                                        width: 280.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                          boxShadow: [],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 80.0,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                        "assets/images/hand-sanitizer.png",
                                                      ),
                                                      fit: BoxFit.fill)),
                                            ),
                                            Center(
                                              child: Text("Use hand sanitizer",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 18.0)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 80.0,
                                        width: 225.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                          boxShadow: [],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 80.0,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                        "assets/images/face-shield.png",
                                                      ),
                                                      fit: BoxFit.fill)),
                                            ),
                                            Center(
                                              child: Text("Use face Shield ",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 18.0)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 80.0,
                                        width: 200.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                          boxShadow: [],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 65.0,
                                              width: 65.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                        "assets/images/mask.png",
                                                      ),
                                                      fit: BoxFit.fill)),
                                            ),
                                            Center(
                                              child: Text("Use masks",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 18.0)),
                                            ),
                                          ],
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
                    ],
                  ),
                ),
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
