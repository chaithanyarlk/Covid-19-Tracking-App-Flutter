import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:maverick_red_2245/authentication_service.dart';
import 'package:maverick_red_2245/screens/homescreen.dart';
import 'package:string_validator/string_validator.dart';
import 'package:maverick_red_2245/screens/loginemail.dart';

class GoogleSignUp extends StatefulWidget {
  @override
  _GoogleSignUpState createState() => _GoogleSignUpState();
}

class _GoogleSignUpState extends State<GoogleSignUp> {
  Auth _auth = Auth();
  TextEditingController _aadharid = TextEditingController();
  TextEditingController _ph = TextEditingController();

  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  bool _obsecure1, _obsecure2;
  double _a;
  int state = 0;
  int state2 = 0;
  
  @override
  void dispose() {
    _aadharid.dispose();
    _ph.dispose();
    super.dispose();
  }

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    
    _obsecure1 = true;
    _obsecure2 = true;
    _a = 1.0;
    check();
  }

  check() async {
    var user = await _auth.getCurrentUser();
    dbref.once().then((DataSnapshot data) {
      Map<dynamic, dynamic> map = data.value;
      map.forEach((key, value) {
        if (value['aadharid'] == _aadharid.text && user.uid == value['uid']) {
          print(value['aadharid']);
          setState(() {
            state = 1;
          });
          print(state);
        }
        if (value['ph'] == _ph.text && user.uid == value['uid']) {
          print(value['ph']);
          setState(() {
            state2 = 1;
          });
          print(state2);
        }
      });
    });
  }

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height * _a,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.1,
                  0.3,
                  0.7,
                  1.0
                ],
                colors: [
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.pink
                ]),
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                centerTitle: true,
                title: new Text(
                  "Security Check",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
              Center(
                child: Image.asset(
                  "assets/images/women-mask.png",
                  scale: 20.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    key: _formkey,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 1.0, bottom: 0.0, left: 25.0, right: 25.0),
                            child: TextFormField(
                              onFieldSubmitted: (term) {
                                FocusScope.of(context).nextFocus();
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(FontAwesome.id_card),
                                labelText: "Aadhar ID",
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              controller: _aadharid,
                              onChanged: (val) {
                                check();
                              },
                              validator: (str) {
                                if (isNumeric(str) == false ||
                                    str.length < 12 ||
                                    str.length > 12 ||
                                    state == 0) {
                                  return ("Please enter a proper aadhar id");
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 1.0, bottom: 0.0, left: 25.0, right: 25.0),
                            child: TextFormField(
                              onFieldSubmitted: (term) {
                                FocusScope.of(context).nextFocus();
                              },
                              decoration: InputDecoration(
                                prefixText: "+91",
                                prefixIcon: Icon(FontAwesome.phone),
                                labelText: "Phone Number",
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              controller: _ph,
                              onChanged: (val) {
                                check();
                              },
                              validator: (str) {
                                if (isNumeric(str) == false ||
                                    str.length < 9 ||
                                    state2 == 0) {
                                  return ("Please enter a proper Phone Number");
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 5.0, bottom: 5.0, left: 25.0, right: 25.0),
                            child: RaisedButton(
                              color: Colors.blue[600],
                              textColor: Colors.white,
                              splashColor: Colors.yellowAccent,
                              onPressed: () async {
                                if (_formkey.currentState.validate()) {
                                  try {
                                    var firebase_user =
                                        await _auth.getCurrentUser();
                                    print(firebase_user);
                                    var userId = await _auth.dataStore(
                                        firebase_user.uid,
                                        firebase_user.email,
                                        firebase_user.displayName,
                                        _aadharid.text,
                                        _ph.text);
                                    print(firebase_user.uid);
                                    return showDialog(
                                      context: context,
                                      builder: (_) => new AlertDialog(
                                        scrollable: false,
                                        title: new Text("Congratulations!"),
                                        content: new Container(
                                          height: 80,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.greenAccent,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: new Text(
                                                    "Authenticated successfully!"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Home(),
                                                  ),
                                                );
                                              },
                                              child: new Text("close"))
                                        ],
                                      ),
                                    );
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                } else {
                                  setState(() {
                                    _a = 1.25;
                                  });
                                }
                              },
                              child: Text("Submit"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
