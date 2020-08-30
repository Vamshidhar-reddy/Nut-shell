import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutshell/model/userdetails.dart';
import 'package:nutshell/paperback.dart';
import 'package:nutshell/login.dart';
import 'package:nutshell/phone.dart';
import 'dart:async';

import 'package:nutshell/subscription.dart';
import 'package:nutshell/users.dart';
import 'package:provider/provider.dart';

import 'database.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  Animation<double> _mainLogoAnimation;
  AnimationController _mainLogoAnimationController;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    _mainLogoAnimationController = new AnimationController(
        duration: new Duration(milliseconds: 1400), vsync: this);
    _mainLogoAnimation = new CurvedAnimation(
        parent: _mainLogoAnimationController, curve: Curves.easeIn);
    _mainLogoAnimation.addListener(() => (this.setState(() {})));
    _mainLogoAnimationController.forward();
    existingUser();
  }

  @override
  void dispose() {
    super.dispose();
    _mainLogoAnimationController.dispose();
  }

  Future existingUser() async {
    final Firestore _firestore = Firestore.instance;

    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      print(user.toString());

      if (user != null) {
        try {
          DocumentSnapshot _docSnap =
              await _firestore.collection("users").document(user.uid).get();

          if (_docSnap.data['subscription']) {
            print(_docSnap.data['subPlan']);
            Provider.of<UserDetails>(context, listen: false)
                .setnoOfPaper(_docSnap.data['subPlan']);
            print(_docSnap.data['group']);

            Provider.of<UserDetails>(context, listen: false)
                .setnoOfPaper(_docSnap.data['group']);
            QuerySnapshot qs = await Firestore.instance
                .collection("Group" + _docSnap.data['group'])
                .orderBy("name")
                .getDocuments();
            print("doc");
            Provider.of<UserDetails>(context, listen: false).setQuery(qs);
            Navigator.pushNamedAndRemoveUntil(
                context, "/bottombar", (_) => false);
            print("object");
          } else {
            Navigator.pushNamed(context, "/subs");
          }
        } catch (_) {
          Fluttertoast.showToast(msg: "Please Check Your Internet Connection");
        }
      } else {
        await new Future.delayed(const Duration(milliseconds: 1300));

        Navigator.pushNamedAndRemoveUntil(context, '/intro', (_) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  Future goToLoginPage() async {
    await new Future.delayed(const Duration(milliseconds: 2000));
    String retVal = "error";

    final FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    // Users _user = Users();
    try {
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      final AuthResult _authResult =
          await _auth.signInWithCredential(credential);
      if (_authResult.additionalUserInfo.isNewUser) {
        Navigator.pushNamedAndRemoveUntil(context, '/intro', (_) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/bottombar", (_) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        // decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/Splashscreenbg.png'))),
        child: SafeArea(
          child: new Center(
              child: new Opacity(
                  opacity: 1.0 * _mainLogoAnimation.value,
                  child: new Hero(
                      tag: 'logo',
                      child: new Image(
                        fit: BoxFit.fill,
                        image: new AssetImage('assets/images/Splash.png'),
                      )))),
        ));
  }
}
