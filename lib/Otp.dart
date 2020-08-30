import 'package:nutshell/ColorAndFonts/Colors.dart';
import 'package:nutshell/model/userdetails.dart';

import 'package:provider/provider.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'database.dart';
import 'global.dart' as g;
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:nutshell/phone.dart';
import 'package:nutshell/short.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Otp extends StatefulWidget {
  String PhoneNo;
  Otp({this.PhoneNo});
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> with TickerProviderStateMixin {
  bool _resendEnble = false;
  bool _continueEnble = false;

  var onTapRecognizer;
  bool _isLoading = false;
  TextEditingController textEditingController;
  //  ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  bool _pinEnable = false;

  String currentText = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void callSnackBar(String msg, [int er]) {
    final SnackBar = new prefix0.SnackBar(
      content: new Text(msg),
      duration: new Duration(seconds: 1),
    );
    _scaffoldKey.currentState.showSnackBar(SnackBar);
  }

  String errorMessage = '';
  String status, actualCode;

  String phoneNo;
  String smsCode;
  String verificationId;
  AuthCredential _authCredential;
  Future<void> verifyPhone() async {
    setState(() {
      _pinEnable = false;
      _continueEnble = false;
      _isLoading = true;
      _resendEnble = false;
    });
    var firebaseAuth = await FirebaseAuth.instance;

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.actualCode = verificationId;

      setState(() {
        _isLoading = false;
        _pinEnable = true;
        this.actualCode = verificationId;

        textEditingController = TextEditingController();

        print('Code sent to ${widget.PhoneNo}');
        callSnackBar("Code sent to ${widget.PhoneNo}");
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.actualCode = verificationId;
      print("timeout");
      callSnackBar("Auto retrieval failed");
      setState(() {
        status = "\nAuto retrieval time out";
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        status = '${authException.message}';
        callSnackBar("Please enter a valid phone number");
        Fluttertoast.showToast(
          timeInSecForIosWeb: 3,
          msg: "Please enter a valid phone number",
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Phone()));

        print("Error message: " + status);
        if (authException.message.contains('not authorized'))
          status = 'Something has gone wrong, please try later';
        else if (authException.message.contains('Network'))
          Fluttertoast.showToast(
            timeInSecForIosWeb: 3,
            msg: "Please check your internet connection and try again",
          );
        else
          status = 'Something has gone wrong, please try later';
      });
    };
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
      setState(() {
        status = 'Auto retrieving verification code';
      });
      callSnackBar("Auto retrieving verification code");

      _authCredential = auth;
      print("auth");

      firebaseAuth
          .signInWithCredential(_authCredential)
          .then((AuthResult value) async {
        if (value.additionalUserInfo.isNewUser) {
          print(value.user.uid);
          print("firest uset");
          OurDatabase().createUser();

          return Navigator.pushNamed(context, '/subs');
        }
        setState(() {
          status = 'Authentication successful';
        });
        final Firestore _firestore = Firestore.instance;

        try {
          FirebaseUser user = await FirebaseAuth.instance.currentUser();
          print(user.toString());

          if (user != null) {
            DocumentSnapshot _docSnap =
                await _firestore.collection("users").document(user.uid).get();

            if (_docSnap.data['subscription']) {
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

              Navigator.pushNamedAndRemoveUntil(
                  context, "/bottombar", (_) => false);
            } else {
              g.isGLogin = false;
              Navigator.pushNamed(context, "/subs");
            }
          } else {
            setState(() {
              _isLoading = false;
            });
            Navigator.pushNamedAndRemoveUntil(context, "/intro", (_) => false);
          }
        } catch (e) {
          print(e);
        }
      });
    };
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: widget.PhoneNo,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void initState() {
    verifyPhone();

    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();

    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> PhoneS(String smsCode) async {
    setState(() {
      _isLoading = true;
      _resendEnble = false;
    });
    callSnackBar("Validating otp");

    FirebaseAuth firebaseAuth = await FirebaseAuth.instance;
    print("smscode $smsCode");
    print("actual code $actualCode");

    _authCredential = await PhoneAuthProvider.getCredential(
        verificationId: actualCode, smsCode: smsCode);
    firebaseAuth.signInWithCredential(_authCredential).catchError((error) {
      setState(() {
        _resendEnble = true;
        textEditingController.clear();
        _pinEnable = true;
        _continueEnble = false;
        status = 'Something has gone wrong, please try later';
      });
      setState(() {
        _isLoading = false;
      });
      callSnackBar("Otp timeout or invalid Otp");
    }).then((user) async {
      if (user.additionalUserInfo.isNewUser) {
        print(user.user.uid);
        OurDatabase().createUser();

        return Navigator.pushNamed(context, '/subs');
      }
      setState(() {
        _isLoading = false;
        status = 'Authentication successful';
      });
      final Firestore _firestore = Firestore.instance;

      try {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        print(user.toString());
        setState(() {
          _isLoading = false;
        });
        if (user != null) {
          DocumentSnapshot _docSnap =
              await _firestore.collection("users").document(user.uid).get();

          // await new Future.delayed(const Duration(milliseconds: 5000));
          if (_docSnap.data['subscription']) {
            setState(() {
              _isLoading = false;
            });
            Navigator.pushNamedAndRemoveUntil(
                context, "/paperback", (_) => false);
          } else {
            setState(() {
              _isLoading = false;
            });
            Navigator.pushNamed(context, "/subs");
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamedAndRemoveUntil(context, "/intro", (_) => false);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(e);
      }
    });
  }

  String SmsValidator(String value) {
    if (value.length != 6 || value.length == null) {
      print("validation failed");

      // return 'Phone Number must be of 10 digits';
      callSnackBar(
          "Please Enter Proper 6 digit SMS code sent to your Mobile Number");
    } else {
      callSnackBar("You are signing in please wait !!");
      PhoneS(value);
    }
    // return null;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: new IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30.0,
              color: Colors.black,
            ),
            tooltip: 'back',
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Phone()));
            },
          ),
        ),
        key: _scaffoldKey,
        body: WillPopScope(
          onWillPop: () {
            textEditingController.clear();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Phone()));
          },
          child: ListView(children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    left: 20.0, top: 20.0, right: 10.0, bottom: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Image(
                          fit: BoxFit.fill,
                          image: mainLogo,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Text(
                      'Verifying your mobile number',
                      style: TextStyle(
                          fontSize: headings,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '0:30',
                            style: TextStyle(
                                fontSize: 23,
                                color:
                                    _resendEnble ? Colors.black : Colors.grey),
                          ),
                          FlatButton(
                            onPressed: () =>
                                _resendEnble ? verifyPhone() : null,
                            child: Text(
                              'Resend otp',
                              style: TextStyle(
                                  fontSize: 23,
                                  color: _resendEnble
                                      ? Colors.black
                                      : Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                    PinCodeTextField(
                      enabled: _pinEnable,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      length: 6,
                      autoValidate: true,
                      obsecureText: false,
                      enableActiveFill: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 60,
                          fieldWidth: 45,
                          activeFillColor: Colors.grey[300],
                          inactiveFillColor: Colors.grey[300],
                          selectedFillColor: Colors.white,
                          inactiveColor: Colors.grey),
                      animationDuration: Duration(milliseconds: 300),
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      onCompleted: (v) {
                        print("Completed");
                      },
                      validator: (v) {
                        if (v.length == 6) {
                          setState(() {
                            _isLoading = true;
                          });
                          Future.delayed(Duration(seconds: 5));
                          setState(() {
                            _isLoading = false;
                          });

                          _continueEnble = true;
                        } else {
                          _continueEnble = false;
                        }
                      },
                      onChanged: (value) {
                        print(value);

                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: RaisedButton(
                        color: _continueEnble ? mainColor : Colors.grey,
                        onPressed: () =>
                            _continueEnble ? SmsValidator(currentText) : null,
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                'SUbmit',
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
