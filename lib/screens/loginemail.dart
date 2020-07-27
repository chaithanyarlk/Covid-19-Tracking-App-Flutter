import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:maverick_red_2245/authentication_service.dart';
import 'package:maverick_red_2245/screens/googleSignUp.dart';
import 'package:maverick_red_2245/screens/homescreen.dart';
import 'package:maverick_red_2245/screens/signup.dart';
import 'package:maverick_red_2245/screens/forgotpassword.dart';
import 'package:string_validator/string_validator.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Auth _auth = Auth();
  TextEditingController _email = TextEditingController();
  TextEditingController _password1 = TextEditingController();
  bool _obsecure1;
  final databaseReference = FirebaseDatabase.instance.reference();
  int state = 2;

  @override
  void dispose() {
    _email.dispose();
    _password1.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obsecure1 = true;
    checkUser(" ");
  }

  final _formkey = GlobalKey<FormState>();

  checkUser(String uid) async {
    await databaseReference.once().then((DataSnapshot data) {
      Map<dynamic, dynamic> map = data.value;
      map.forEach((key, value) {
        if (value['uid'] == uid) {
          print(value['uid']);
          print("matched");
          setState(() {
            state = 1;
          });
          print(state); //1 means user aldready exists
        }
      });
      if (state != 1) {
        state = 0;
      }
    });
    return state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                centerTitle: true,
                title: new Text(
                  "SignIn with Email",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
              Image.asset(
                "assets/images/Bodytemp.png",
                scale: 8.0,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
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
                                  top: 1.0,
                                  bottom: 0.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: TextFormField(
                                onFieldSubmitted: (term) {
                                  FocusScope.of(context).nextFocus();
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  labelText: "Email",
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
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
                                  top: 1.0,
                                  bottom: 0.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: TextFormField(
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
                                controller: _password1,
                                obscureText: _obsecure1,
                                validator: (str) {
                                  print(str);
                                  if (str == "") {
                                    print(isAlphanumeric(str));
                                    return ("This field is required!");
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 5.0,
                                  bottom: 2.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: RaisedButton(
                                color: Colors.blue[600],
                                textColor: Colors.white,
                                splashColor: Colors.yellowAccent,
                                onPressed: () async {
                                  if (_formkey.currentState.validate()) {
                                    try {
                                      var userId = await _auth.signIn(
                                        _email.text,
                                        _password1.text,
                                      );
                                      print(userId);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Home(),
                                        ),
                                      );
                                    } catch (e) {
                                      print(e.toString());
                                      return showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Invalid login"),
                                          content: Text(
                                              "Please check the email and password that you have entered!"),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Close"),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text("Sign In"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: InkWell(
                                onTap: () {
                                  print("pressed SignUp");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUp(),
                                    ),
                                  );
                                },
                                child: new Text(
                                  "Don't have an Account?",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: InkWell(
                                onTap: () {
                                  print("forgot");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Forgot(),
                                    ),
                                  );
                                },
                                child: new Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FlatButton(
                                color: Colors.white,
                                
                                onPressed: () async {
                                  var user = await _auth.signInWithGoogle();
                                  print(user);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GoogleSignUp(),
                                      ),
                                    );
                                   
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 25.0,
                                        width: 25.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/google.png"),
                                                fit: BoxFit.fill)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: Text("SignIn with Google",style: TextStyle(fontSize: 15.0,decoration: TextDecoration.underline),),
                                      ),
                                    ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
