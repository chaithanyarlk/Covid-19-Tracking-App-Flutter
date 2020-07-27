import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:maverick_red_2245/authentication_service.dart';
import 'package:maverick_red_2245/models/cases.dart';
import 'package:http/http.dart' as http;
import 'package:maverick_red_2245/models/cases_list.dart';
import 'package:maverick_red_2245/models/cases_state.dart';
//import 'package:maverick_red_2245/models/Caseslist_fetch.dart';
import 'dart:convert';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:maverick_red_2245/screens/navbar.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

Future<CasesList> fetchCases() async {
  final response = await http.get("https://api.covid19india.org/data.json");
  if (response.statusCode == 200) {
    return CasesList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

class Caseslist extends StatefulWidget {
  @override
  _CaseslistState createState() => _CaseslistState();
}

class _CaseslistState extends State<Caseslist> {
  Auth _auth = Auth();
  Future<CasesList> futurecases;
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  String name = " ";
  String ph = " ";
  String aadhar = " ";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futurecases = fetchCases();
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
                        onPressed: ()  {
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
                        "assets/images/india.png",
                        scale: 6.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Statewise",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                          Text(
                            "Updates ...",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                FutureBuilder<CasesList>(
                  future: futurecases,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.578,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 12.0),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.cases.length,
                            itemBuilder: (context, index) => Container(
                              
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors:  index%2==0?MoreGradientColors.darkSkyBlue:(index%3==0?GradientColors.beautifulGreen:MoreGradientColors.instagram),
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.rectangle,
                                  
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[300],
                                      blurRadius: 5.0,
                                      spreadRadius: 10.0,
                                      offset: Offset(5.0, 5.0),
                                    )
                                  ]),
                              child: GestureDetector(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    index==0?Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          "${snapshot.data.cases[index].state}",style: TextStyle(color: Colors.white,fontSize: 18.0),),
                                    ):Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          "State : ${snapshot.data.cases[index].state}",style: TextStyle(color: Colors.white,fontSize: 18.0),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          "Confirmed Cases : ${snapshot.data.cases[index].confirmed}",style: TextStyle(color: Colors.white,fontSize: 18.0),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          "Active Cases : ${snapshot.data.cases[index].active}",style: TextStyle(color: Colors.white,fontSize: 18.0),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          "Recovered : ${snapshot.data.cases[index].recovered}",style: TextStyle(color: Colors.white,fontSize: 18.0),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          "Deaths : ${snapshot.data.cases[index].deaths}",style: TextStyle(color: Colors.white,fontSize: 18.0),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          "Active : ${snapshot.data.cases[index].active}",style: TextStyle(color: Colors.white,fontSize: 18.0),),
                                    ),
                                    index==0?Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          "State Code : ",style: TextStyle(color: Colors.white,fontSize: 18.0),),
                                    ):Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          "State Code : ${snapshot.data.cases[index].statecode}",style: TextStyle(color: Colors.white,fontSize: 18.0),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          "Last Updated : ${snapshot.data.cases[index].lastupdated}",style: TextStyle(color: Colors.white,fontSize: 18.0),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Text("Error in loading Caseslist");
                    }
                    return Center(
                      child: new CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
