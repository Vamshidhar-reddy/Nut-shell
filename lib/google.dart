import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutshell/account.dart';
import 'package:nutshell/database.dart';
import 'package:nutshell/global.dart' as global;
import 'package:nutshell/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutshell/model/userdetails.dart';

import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
Users _currentUser = Users();
Users get getCurrentUser => _currentUser;
Future<String> signInWithGoogle(BuildContext context) async {
  final Firestore _firestore = Firestore.instance;
  String retVal = "error";
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  Users _user = Users();

  try {
    print("trying jp to login with mail");
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
    final AuthResult _authResult = await _auth.signInWithCredential(credential);

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (_authResult.additionalUserInfo.isNewUser) {
      print("new user");
      _user.uid = _authResult.user.uid;   
      // global.timecreate = DateTime.now();
      _user.email = _authResult.user.email;
      global.email = _authResult.user.email;
      _user.fname = _authResult.user.displayName;

      global.name = _authResult.user.displayName;
      _user.photoUrl = _authResult.user.photoUrl.toString();
      global.photoUrl = _authResult.user.photoUrl.toString();
      print("name" + _user.fname);
      OurDatabase().createUser();
      global.isGLogin = true;
      Navigator.pushNamedAndRemoveUntil(context, '/subs', (_) => false);
    } else {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      print("current user id");
      print(user.uid);

      print("existing user");
      DocumentSnapshot _docSnap =
          await _firestore.collection("users").document(user.uid).get();

      if (_docSnap.data['subscription']) {
        print("Already subscribed");
        global.isGLogin = true;
        //changes
        Provider.of<UserDetails>(context, listen: false)
            .setnoOfPaper(_docSnap.data['subPlan']);

        Provider.of<UserDetails>(context, listen: false)
            .setnoOfPaper("Group" + _docSnap.data['group']);
        QuerySnapshot qs = await Firestore.instance
            .collection("Group" + _docSnap.data['group'])
            .orderBy("name")
            .getDocuments();
        print("doc");
        Provider.of<UserDetails>(context, listen: false).setQuery(qs);

        Navigator.pushNamedAndRemoveUntil(context, "/bottombar", (_) => false);
      } else {
        print("going for subscription");
        global.isGLogin = true;

        Navigator.pushNamed(context, "/subs");
      }
    }
    _currentUser = await OurDatabase().getUserInfo(_authResult.user.uid);

    if (_currentUser != null) {
      retVal = "success";
    }
  } on PlatformException catch (e) {
    retVal = e.message;
  } catch (e) {
    print(e);
  }

  return retVal;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();
  print("User Sign Out");
}
