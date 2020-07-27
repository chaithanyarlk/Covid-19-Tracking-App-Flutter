import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:maverick_red_2245/authentication_service.dart';
import 'package:maverick_red_2245/screens/assit.dart';
import 'package:maverick_red_2245/screens/homescreen.dart';
import 'package:maverick_red_2245/screens/loginemail.dart';
import 'package:maverick_red_2245/screens/emergency.dart';

import 'package:maverick_red_2245/screens/news.dart';
import 'package:maverick_red_2245/screens/statewise_cases.dart';
import 'package:maverick_red_2245/screens/qr_display.dart';
import 'package:maverick_red_2245/screens/qr_scan.dart';
import 'package:maverick_red_2245/screens/rasie_funds.dart';
import 'package:maverick_red_2245/screens/help_desk.dart';
class NavDrawer extends StatelessWidget {
  Auth _auth = Auth();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 1.0],
                    colors: [Colors.lightBlue, Colors.white]),
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/humaaans.png",
                    ),
                    colorFilter: ColorFilter.mode(
                        Colors.blueGrey.withOpacity(0.02), BlendMode.srcOver),
                    fit: BoxFit.fitHeight)),
          ),
          ListTile(
            leading: Icon(FontAwesome.home),
            title: Text("Home Page"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesome.heartbeat),
            title: Text("Assit your health"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Assit()),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesome.user_md),
            title: Text("Emergency Numbers"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Call()),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesome.newspaper_o),
            title: Text("Latest news"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => News()),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesome.line_chart),
            title: Text("Statewise Cases"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Caseslist()),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesome.qrcode),
            title: Text("Display QR code"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Display()),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesome.crosshairs),
            title: Text("Scan QR code"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Scan()),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesome.money),
            title: Text("Donate to Relief Funds"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Funds()),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesome.question_circle),
            title: Text("Help Desk"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Help()),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesome.sign_out),
            title: Text("Sign Out"),
            onTap: () async {
              await _auth.signOut();
              Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) {
                return SignIn();
              }, transitionsBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation, Widget child) {
                return new SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              }),
              (Route route) => false);
            },
          ),
        ],
      ),
    );
  }
}
