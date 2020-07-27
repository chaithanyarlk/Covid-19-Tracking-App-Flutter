import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:maverick_red_2245/authentication_service.dart';
import 'package:maverick_red_2245/screens/homescreen.dart';
import 'package:maverick_red_2245/screens/signup.dart';
import 'package:maverick_red_2245/screens/loginemail.dart';
import 'package:string_validator/string_validator.dart';

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  Auth _auth = Auth();
  TextEditingController _email = TextEditingController();
  
  bool _obsecure1;

  @override
  void dispose() {
    _email.dispose();
    
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obsecure1 = true;
  }

  final _formkey = GlobalKey<FormState>();

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
                  "Forgot Password",
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
                                      var userId = await _auth.sendPasswordResetEmail(
                                        _email.text,
                                        
                                      );
                                      
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignIn(),
                                        ),
                                      );
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  }
                                },
                                child: Text("Submit"),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignIn(),
                                    ),
                                  );
                                },
                                child: new Text(
                                  "SignIn using Email",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
