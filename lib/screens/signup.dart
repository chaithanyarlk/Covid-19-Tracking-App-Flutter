import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:maverick_red_2245/authentication_service.dart';
import 'package:string_validator/string_validator.dart';
import 'package:maverick_red_2245/screens/loginemail.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Auth _auth = Auth();
  TextEditingController _email = TextEditingController();
  TextEditingController _password1 = TextEditingController();
  TextEditingController _password2 = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _aadharid = TextEditingController();
  TextEditingController _ph = TextEditingController();
  FocusNode email = FocusNode();
  FocusNode password1 = FocusNode();
  FocusNode password2 = FocusNode();
  FocusNode name = FocusNode();
  FocusNode ph = FocusNode();
  FocusNode aadhar = FocusNode();
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  bool _obsecure1, _obsecure2;
  double _a;
  int state = 0;
  int state2 = 0;
  @override
  void dispose() {
    _email.dispose();
    _password1.dispose();
    _password2.dispose();
    _name.dispose();
    _aadharid.dispose();
    _ph.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obsecure1 = true;
    _obsecure2 = true;
    _a = 1.0;
    check();
  }

  check() {
    dbref.once().then((DataSnapshot data) {
      Map<dynamic, dynamic> map = data.value;
      map.forEach((key, value) {
        if (value['aadharid'] == _aadharid.text) {
          print(value['aadharid']);
          setState(() {
            state = 1;
          });
          print(state);
        } else {
          setState(() {
            state = 0;
          });
        }
        if (value['ph'] == _ph.text) {
          print(value['ph']);
          setState(() {
            state2 = 1;
          });
          print(state2);
        } else {
          setState(() {
            state2 = 0;
          });
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
                  "SignUp",
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
                                top: 0.0, bottom: 0.0, left: 25.0, right: 25.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(FontAwesome.user),
                                labelText: "Full Name",
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              controller: _name,
                              textCapitalization: TextCapitalization.words,
                              autofocus: false,
                              onFieldSubmitted: (term) {
                                FocusScope.of(context).nextFocus();
                              },
                              validator: (val) {
                                if ((val) == null) {
                                  return ("Please enter a proper Name");
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 1.0, bottom: 0.0, left: 25.0, right: 25.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                FocusScope.of(context).nextFocus();
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: "Email",
                              ),
                              keyboardType: TextInputType.emailAddress,
                              controller: _email,
                              validator: (val) {
                                if (isEmail(val) == false) {
                                  return ("Please enter a proper Email");
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
                                    state == 1) {
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
                              validator: (str) {
                                if (isNumeric(str) == false ||
                                    str.length < 9 ||
                                    state2 == 1) {
                                  return ("Please enter a proper Phone Number");
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
                                prefixIcon: Icon(FontAwesome.lock),
                                labelText: "Password",
                                suffixIcon: IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      setState(() {
                                        _obsecure1 = !(_obsecure1);
                                      });
                                    }),
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              controller: _password1,
                              obscureText: _obsecure1,
                              validator: (str) {
                                if (isAlphanumeric(str) == false ||
                                    str.length <= 6) {
                                  print(isAlphanumeric(str));
                                  return ("Password is too weak please set a new one");
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 1.0, bottom: 0.0, left: 25.0, right: 25.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                FocusScope.of(context).nextFocus();
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesome.lock),
                                  labelText: "Confirm Password",
                                  suffixIcon: IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        setState(() {
                                          _obsecure2 = !(_obsecure2);
                                        });
                                      })),
                              obscureText: _obsecure2,
                              controller: _password2,
                              keyboardType: TextInputType.text,
                              validator: (str) {
                                if (equals(str, _password1.text) == false) {
                                  return ("Passwords do't match.Please Check once!");
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
                                    var userId = await _auth.signUp(
                                        _email.text,
                                        _password1.text,
                                        _name.text,
                                        _aadharid.text,
                                        _ph.text);
                                    print(userId);
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
                                                    "Your Account has been created Successfully!"),
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
                                                        SignIn(),
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
                              child: Text("Sign Up"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(3.0),
                            child: InkWell(
                              onTap: () {
                                print("pressed login");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignIn(),
                                  ),
                                );
                              },
                              child: new Text(
                                "Aldready have an account?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
