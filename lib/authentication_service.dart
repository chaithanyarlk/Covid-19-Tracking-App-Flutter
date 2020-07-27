//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maverick_red_2245/screens/googleSignUp.dart';
import 'package:maverick_red_2245/screens/homescreen.dart';
//import 'package:maverick_red_2245/screens/otp_mobile.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(
      String email, String password, String name, String number, String ph);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    print("came");
    print(user.uid);
    return user.uid;
  }

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  int checker(String aadharid) {
    int s = 0;
    databaseReference.once().then((DataSnapshot data) {
      Map<dynamic, dynamic> map = data.value;
      map.forEach((key, value) {
        if (value['aadharid'] == aadharid) {
          print(value['aadharid']);
          s = 1;
          print(s);
        }
      });
    });
    if (s == 1) {
      print("came into");
      return (s);
    }
    return (s);
  }

  Future<String> dataStore(
      String uid, String email, String name, String aadharid, String ph) {
    databaseReference.child(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'aadharid': aadharid,
      'ph': ph,
    });
  }

  Future<String> signUp(String email, String password, String name,
      String aadharid, String ph) async {
    int state = 1;

    if (state == 1) {
      print("came");
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      print(user.uid);
      databaseReference.child(user.uid).set({
        'uid': user.uid,
        'name': name,
        'aadharid': aadharid,
        'ph': ph,
        'email': email,
      });
      return user.uid;
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    googleSignIn.signOut();
    _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /*mobileotp(String phone, BuildContext context) {
    Fluttertoast.showToast(
      msg: "OTP verification will be sent",
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.yellow,
      textColor: Colors.white,
    );
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: (AuthCredential credential) async {
          AuthResult result =
              await _firebaseAuth.signInWithCredential(credential);
          FirebaseUser user = result.user;
          Fluttertoast.showToast(
              msg: "If user is previously registered Auto will be done",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.yellow,
              textColor: Colors.white);
          if (user != null) {
            Fluttertoast.showToast(
                msg: "User has authenticated",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.yellow,
                textColor: Colors.white);
            final snapShot = await Firestore.instance
                .collection('users')
                .document(user.uid)
                .get();
            if (snapShot == null || !snapShot.exists) {
              //move to take details
            }
          } else {
            Fluttertoast.showToast(
              msg: 'User registering First time',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        },
        verificationFailed: (AuthException ex) {
          print(ex.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerify(verificationId, phone),
            ),
          );
        },
        codeAutoRetrievalTimeout: null);
  }

  verificationotp(String phone, String code, verficationId, context) async {
    final temp = code.trim();
    AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verficationId, smsCode: temp);
    AuthResult result = await FirebaseAuth.instance
        .signInWithCredential(credential)
        .catchError((e) => Fluttertoast.showToast(
              msg: e.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
            ));
    FirebaseUser user = result.user;
    if (user != null) {
      Fluttertoast.showToast(msg: "User signed in");
      print(user.uid);
      final snapShot =
          await Firestore.instance.collection('users').document(user.uid).get();
      //profile page push
      if (snapShot == null || !snapShot.exists) {
        //get details
      } else {}
    } else {
      print("error");
    }
  }*/
}
