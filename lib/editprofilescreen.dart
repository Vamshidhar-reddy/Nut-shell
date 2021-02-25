import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nutshell/ColorAndFonts/Colors.dart';
import 'package:nutshell/paperback.dart';
import 'package:nutshell/orderConfirmation.dart';
import 'package:nutshell/users.dart';

import 'database.dart';
import 'subscription.dart';

String phone;
String email;

TextEditingController _fnamecontroller = TextEditingController();
TextEditingController _emailcontroller = TextEditingController();
TextEditingController _schoolcontroller = TextEditingController();
TextEditingController _phonecontroller = TextEditingController();

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _validate = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Users _currentUser = Users();

  Users get getCurrentUser => _currentUser;
  bool isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> onStartUp() async {
    String retVal = "error";

    try {
      setState(() {
        isLoading = true;
        _dropformSelected = _currentUser.group == null
            ? "Select Group"
            : _currentUser.group.toString();
      });
      FirebaseUser _firebaseUser = await _auth.currentUser();
      print(_firebaseUser.email);
      if (_firebaseUser != null) {
        print(_firebaseUser.uid);
        _currentUser = await OurDatabase().getUserInfo(_firebaseUser.uid);
        if (_currentUser != null) {
          retVal = "success";
          print("in if ");
          print(_currentUser.phone);
          setState(() {
            isLoading = false;
            _fnamecontroller = TextEditingController(
                text: _currentUser.fname == null
                    ? "Full Name"
                    : _currentUser.fname);
            _schoolcontroller = TextEditingController(
                text: _currentUser.school == null
                    ? "School"
                    : _currentUser.school);
            _emailcontroller = TextEditingController(
                text:
                    _currentUser.email == null ? "Email" : _currentUser.email);
            _phonecontroller = TextEditingController(
                text:
                    _currentUser.phone == null ? "Phone" : _currentUser.phone);
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  @override
  void initState() {
    super.initState();
    onStartUp();
    Future.delayed(Duration.zero, () {
      setState(() {
        _schoolcontroller = TextEditingController(
            text: _currentUser.school == null ? "School" : _currentUser.school);
      });
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final text = TextEditingController();
  bool enable_btn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30.0,
            color: Colors.black,
          ),
          tooltip: 'back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: new Form(
                key: _formKey,
                autovalidate: _validate,
                child: FormUI(),
              ),
            ),
    );
  }

  var _dropforms = ['Select Group', 'Group-A', 'Group-B'];
  var _dropformSelected;

  Widget FormUI() {
    _currentUser.sID = sID;
    bool selected = false;
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 1.0,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/details.png"),
                fit: BoxFit.cover)),
        padding: EdgeInsets.only(left: 25.0, right: 25),
        child:
            // Text("\n"),
            Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            TextFormField(
                autofocus: false,
                controller: _fnamecontroller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    // floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    // hintText: _currentUser.fname.toString(),
                    labelText: 'First Name'
                    // hintText: _currentUser.fname.toString()
                    ),
                validator: validateName,
                onSaved: (String value) {
                  _currentUser.fname = value;
                }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            TextFormField(
                controller: _schoolcontroller,
                // autovalidate: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  labelText: 'School',
                  // hintText: _currentUser.school.toString()
                ),
                validator: validateName,
                onSaved: (String value) {
                  _currentUser.school = value;
                }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            TextFormField(
                controller: _emailcontroller,
                decoration: InputDecoration(
                    // floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    // hintText: _currentUser.email.toString(),
                    labelText: 'Email'
                    // hintText:
                    ),
                // validator: validateClass,
                onSaved: (String value) {
                  _currentUser.email = value;
                }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            TextFormField(
                maxLength: 10,
                controller: _phonecontroller,
                autovalidate: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                  counterText: "",
                  // hintText: _currentUser.phone.toString(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  labelText: 'Phone No',
                ),
                validator: (String txt) {
                  if (txt.length == 10) {
                    Future.delayed(Duration.zero).then((_) {
                      setState(() {
                        enable_btn = true;
                      });
                    });
                  } else {
                    enable_btn = false;
                  }
                },
                onSaved: (String value) {
                  _currentUser.phone = value;
                }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
              // width: MediaQuery.of(context).size.width * 0.85,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onPressed: enable_btn == true
                    ? () {
                        sendToServer();
                      }
                    : null,
                color: mainColor,
                child: Text(
                  "Update",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendToServer() async {
    // Users _user = Users();
    if (_formKey.currentState.validate()) {
      // No any error in validation
      _formKey.currentState.save();
      Navigator.pushNamed(context, "/account");
      print("CLicked successfully");
      OurDatabase().updateDetails(_currentUser);
      print("updated user user");
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
}

String validateName(String value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length <= 2) {
    return "Name is Required";
  } else if (!regExp.hasMatch(value)) {
    return "Name must be a-z and A-Z";
  }
  return null;
}

String validateSchool(String value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length <= 2) {
    return "School Name is Required";
  } else if (!regExp.hasMatch(value)) {
    return "Special characters not allowed";
  }
  return null;
}

// String validateClass(String value) {
//   String pattern = '([0-2]{2}|[123456789])';
//   RegExp regExp = new RegExp(pattern);
//   if (value.length == 0) {
//     return "Class is Required";
//   } else if (!regExp.hasMatch(value)) {
//     return "Class must be between 1-12";
//   }
//   return null;
// }

String validatePhone(String value) {
  String pattern = '([0-9])';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Phone Number Required";
  } else if (!regExp.hasMatch(value)) {
    return "Enter Phone Number";
  }
  return null;
}

// String validateCity(String value) {
//   String pattern = r'(^[a-zA-Z ]*$)';
//   RegExp regExp = new RegExp(pattern);
//   if (value.length == 0) {
//     return "City is Required";
//   } else if (!regExp.hasMatch(value)) {
//     return "Please enter a valid City";
//   }
//   return null;
// }
