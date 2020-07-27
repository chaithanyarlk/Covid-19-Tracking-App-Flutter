import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:maverick_red_2245/authentication_service.dart';
import 'package:maverick_red_2245/models/cases.dart';
import 'package:http/http.dart' as http;
import 'package:maverick_red_2245/models/news_fetch.dart';
import 'dart:convert';

import 'package:maverick_red_2245/screens/navbar.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

Future<News_List> fetchNews() async {
  String t = DateTime.now().toString().split(" ")[0];
  print(t);
  final response = await http.get(
      "http://newsapi.org/v2/everything?q=Covid19&from=" +
          t +
          "&sortBy=popularity&apiKey=c2e1bd0454d64b839486964dbea13e00");
  if (response.statusCode == 200) {
    return News_List.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  Auth _auth = Auth();
  Future<News_List> futurenews;
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  String name = " ";
  String ph = " ";
  String aadhar = " ";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futurenews = fetchNews();
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
                        "assets/images/newspaper.png",
                        scale: 6.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Get latest",
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
                FutureBuilder<News_List>(
                  future: futurenews,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 12.0),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.news_list.length,
                            itemBuilder: (context, index) => Container(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height * 0.525,
                              decoration: BoxDecoration(
                                  color: Colors.white,
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
                                onTap: () async {
                                  if (await canLaunch(
                                      snapshot.data.news_list[index].url)) {
                                    await launch(
                                        snapshot.data.news_list[index].url);
                                  } else {
                                    throw "Colud not Launch Url";
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 200.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: snapshot
                                                          .data
                                                          .news_list[index]
                                                          .imageurl ==
                                                      null
                                                  ? AssetImage(
                                                      "assets/images/newspaper.png")
                                                  : NetworkImage(snapshot
                                                      .data
                                                      .news_list[index]
                                                      .imageurl),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            100.0, //snapshot.data.news_list[index].content.toString().length<=250?150.0:300.0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 50.0,
                                              padding: EdgeInsets.all(2.0),
                                              child: Text(
                                                snapshot.data.news_list[index]
                                                    .title,
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                            snapshot.data.news_list[index]
                                                        .content ==
                                                    null
                                                ? Container(
                                                    height: 50.0,
                                                    padding:
                                                        EdgeInsets.all(2.0),
                                                    child: Text(
                                                      "No content Available",
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      overflow:
                                                          TextOverflow.fade,
                                                    ),
                                                  )
                                                : Container(
                                                    height: 50.0,
                                                    padding:
                                                        EdgeInsets.all(2.0),
                                                    child: Text(
                                                      snapshot
                                                          .data
                                                          .news_list[index]
                                                          .content,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                      ),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 8.0,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.transparent,
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
                      return Text("Error in loading news");
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
