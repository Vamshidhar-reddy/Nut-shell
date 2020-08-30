import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutshell/currentUser.dart';
import 'package:nutshell/users.dart';
import '../database.dart';
import 'extendplan.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutshell/global.dart' as global;

String exemail, exphone;

class ExtendOrder extends StatefulWidget {
  @override
  _ExtendOrderState createState() => _ExtendOrderState();
}

class _ExtendOrderState extends State<ExtendOrder> {
  bool btn_enable = false;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  bool isLoading = false;
  var today;
  Users _currentUser = Users();
  Users get getCurrentUser => _currentUser;

  FirebaseAuth auth = FirebaseAuth.instance;

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();

    final uid = user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        // Navigator.of(context).popUntil(ModalRoute.withName('/pricing'));
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(children: <Widget>[
            Form(
              key: _formKey,
              child: Container(
                  padding: EdgeInsets.only(
                      left: 20.0, top: 10.0, bottom: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Thank You for your order!',
                        style: TextStyle(
                          fontSize: 75.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(109, 0, 109, 1),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Order ID:',
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '45...',
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Subscription type:',
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              payone == 1
                                  ? "Basic"
                                  : paytwo == 1
                                      ? "Standard"
                                      : paythree == 1 ? "Premium" : "Error",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Valid till:',
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              payone == 1
                                  ? "30 Days"
                                  : paytwo == 1
                                      ? "6 Months"
                                      : paythree == 1 ? "1 year" : "Error",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Divider(
                        thickness: 2.0,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Subtotal:',
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              payone == 1
                                  ? "  ₹ 199"
                                  : paytwo == 1
                                      ? " ₹ 699"
                                      : paythree == 1 ? " ₹ 1000" : "Error",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Text(
                        'Enter E-Mail and Phone Number to checkout',
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter email';
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        autovalidate: true,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        validator: (String txt) {
                          if (txt.length == 10) {
                            Future.delayed(Duration.zero).then((_) {
                              setState(() {
                                btn_enable = true;
                                // global.ins = txt;
                              });
                            });
                          } else {
                            Future.delayed(Duration.zero).then((_) {
                              setState(() {
                                btn_enable = false;
                              });
                            });
                          }
                        },
                        controller: phoneController,
                        decoration: InputDecoration(
                            counterText: '',
                            hintText: 'Phone Number',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                      ),
                      RaisedButton(
                          child: Text("Proceed to checkout"),
                          color: Colors.green,
                          textColor: Colors.white,
                          onPressed: btn_enable == true
                              ? () {
                                  if (_formKey.currentState.validate()) {
                                    exemail = emailController.text;
                                    exphone = phoneController.text;
                                  }
                                  if (payone == 1) {
                                    print("proceeding to checkout pay1");
                                    global.subPlan = "b";
                                    openCheckout(context);
                                  } else if (paytwo == 1) {
                                    global.subPlan = "s";
                                    print("proceeding to checkout pay2");
                                    openCheckoutthree(context);
                                  } else if (paythree == 1) {
                                    global.subPlan = "p";
                                    print("proceeding to checkout pay3");
                                    openCheckoutyear(context);
                                  }
                                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => ExtendOrder()));
                                }
                              : null),
                      MaterialButton(onPressed: null)
                    ],
                  )),
            ),
          ])),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons

  Widget continueButton = FlatButton(
    child: Text("Yes"),
    onPressed: () {
      CallForFreeUpdation();
      Navigator.popAndPushNamed(context, "/bottombar");
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Free plan"),
    content: Text(
        " Your free subscription plan ends in 7 days, Continue to Homescreen"),
    actions: [
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void CallForFreeUpdation() async {
  try {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("current user id");
    print(user.uid);

    final Firestore fireStore = Firestore.instance;
    DateTime expiryDate = DateTime.now().add(new Duration(days: 7));
    print(expiryDate);
    await fireStore.collection("users").document(user.uid).updateData({
      "subPlan": global.subPlan,
      "subscription": true,
      "expiryDate": expiryDate
    });
    print("updated free " + global.subPlan);
  } catch (e) {
    print(e.toString());
  }
}
