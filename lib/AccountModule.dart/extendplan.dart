import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutshell/AccountModule.dart/extendorder.dart';
import 'package:nutshell/ColorAndFonts/Colors.dart';

import 'package:nutshell/users.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:js_util';

import '../details.dart';

import 'package:nutshell/global.dart' as global;

bool selection1 = false;

String sID;
Razorpay razorpay;
// int payfree = 0;
int payone = 0;
int paytwo = 0;
int paythree = 0;
final CollectionReference users = Firestore.instance.collection('users');
Users _currentUser = Users();
Users get getCurrentUser => _currentUser;

class Extend extends StatefulWidget {
  @override
  _ExtendState createState() => _ExtendState();
}

enum en { b, s, p }
Map pay = {0: payone, 1: paytwo, 2: paythree};

class _ExtendState extends State<Extend> {
  var oneval = false;
  var twoval = false;

  //
  bool isVisible = false;
  bool isLoading = false;
  int svgIndex;
  var threeval = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  static const List<int> price = [
    // 0,
    129,
    219,
    299,
  ];
  static const Map<String, List<String>> subName = {
    // "Trial": [
    //   "7 Days trial",
    //   "2 FREE issues of Nutshell",
    //   " Digital Paperback",
    // ],
    "4 Month Plan": [
      "2 Digital Paperbacks ",
      "2 Issues of Nutshell Digital Paperback",
      "(Published once every two months)",
      "Plus",
      "2 FREE Digital Paperbacks",
    ],
    "6 Month Plan": [
      "4 Digital Paperbacks",
      "4 Issues of Nutshell Digital Paperback",
      "(Published once every two months)",
      "Plus",
      "2 FREE Digital Paperbacks",
    ],
    "12 Month Plan": [
      "6 Digital Paperbacks ",
      "6 Issues of Nutshell Digital Paperback",
      "(Published once every two months)",
      "Plus",
      "2 FREE Digital Paperbacks",
    ]
  };

  int _activeInd;
  @override
  Widget build(BuildContext context) {
    // callSet(String sv) {
    //   setState(() {
    //     isVisible == true && svgIndex != svgNames.indexOf(sv)
    //         ? isVisible = true
    //         : isVisible = !isVisible;
    //     svgIndex = svgNames.indexOf(sv);
    //   });
    // }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(30, 15, 30, 10),
                child: Image(
                  fit: BoxFit.fill,
                  image: mainLogo,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              "Select a subscription plan",
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                  color: mainColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            Expanded(
              child: new ListView.builder(
                  itemCount: price.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            cardColor: mainColor,
                          ),
                          child: new ExpansionPanelList(
                            expansionCallback: (int index, bool status) {
                              setState(() {
                                _activeInd = _activeInd == i ? null : i;
                              });
                            },
                            children: [
                              new ExpansionPanel(
                                  canTapOnHeader: true,
                                  isExpanded: _activeInd == i,
                                  headerBuilder: (BuildContext context,
                                          bool isExpanded) =>
                                      new Container(
                                          margin: EdgeInsets.fromLTRB(
                                              10, 22, 0, 25),
                                          decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                          ),
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              new Text(subName.keys.toList()[i],
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          "Montserret")),
                                              new Text(
                                                  "₹" + price[i].toString(),
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          )),
                                  body: Container(
                                    width: double.infinity,
                                    color: Color.fromRGBO(161, 236, 166, 1),
                                    child: Column(
                                      children: [
                                        Builder(builder: (context) {
                                          List<Widget> widList = [];
                                          subName.values
                                              .toList()[i]
                                              .forEach((e) {
                                            widList.add(Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, bottom: 2),
                                              child: Text(e,
                                                  key: ObjectKey(e),
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontFamily: "Montserret",
                                                      fontSize: 20,
                                                      color: Colors.black)),
                                            ));
                                          });
                                          widList.add(Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0)),
                                              onPressed: () {
                                                setState(() {
                                                  payone = 0;
                                                  paytwo = 0;
                                                  paythree = 0;
                                                  global.subPlan =
                                                      en.values[i].toString();
                                                  print("index of d sub $i");
                                                  switch (i) {
                                                    case 0:
                                                      {
                                                        print(i);
                                                        payone = 1;
                                                        break;
                                                      }

                                                    case 1:
                                                      {
                                                        paytwo = 1;
                                                        break;
                                                      }
                                                    case 2:
                                                      {
                                                        paythree = 1;
                                                        break;
                                                      }
                                                  }
                                                });

                                                print(pay.values
                                                    .toList()[i]
                                                    .toString());
                                                Navigator.pushNamed(
                                                    context, "/extendorder");
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text("CONFIRM",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Montserret",
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.green)),
                                              ),
                                            ),
                                          ));
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: widList,
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  )
                                  //     Builder(builder: (context) {
                                  //   return ListView.builder(
                                  //       itemCount: 4,
                                  //       itemBuilder: (c, j) {
                                  //         print(j.toString());
                                  //         return Text(
                                  //             subName.values.toList()[i][j],
                                  //             key: ObjectKey(j));
                                  //       });
                                  // })
                                  // ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            // Container(
            //   padding: EdgeInsets.only(
            //       left: MediaQuery.of(context).size.width * 0.4,
            //       right: 10.0,
            //       bottom: 10),

            //   child: RaisedButton(
            //     padding: EdgeInsets.only(
            //         left: 22.0, right: 20.0, top: 10.0, bottom: 10.0),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(25.0)),
            //     onPressed: isVisible == true
            //         ? () {
            //             setState(() {
            //               global.subPlan = en.values[svgIndex].toString();
            //               print("index of svg $svgIndex");
            //               switch (svgIndex) {
            //                 case 0:
            //                   {
            //                     payfree = 1;
            //                     break;
            //                   }
            //                 case 1:
            //                   {
            //                     payone = 1;
            //                     break;
            //                   }

            //                 case 2:
            //                   {
            //                     paytwo = 1;
            //                     break;
            //                   }
            //                 case 3:
            //                   {
            //                     paythree = 1;
            //                     break;
            //                   }
            //               }
            //             });

            //             print(pay.values.toList()[svgIndex].toString());
            //             Navigator.push(context,
            //                 MaterialPageRoute(builder: (context) => Details()));
            //           }
            //         : null,
            //     disabledColor: Colors.grey,
            //     color: Color.fromRGBO(109, 0, 109, 1),
            //     child: Center(
            //       child: Text(
            //         'Continue',
            //         style:
            //             TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ),
            //   // ),
            // )
          ],
        )
        // )
        );
  }

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
    setState(() {
      selection1 = false;
      payone = 0;
      paythree = 0;
      paytwo = 0;
    });
  }
}

void openCheckout(BuildContext context) async {
  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
      msg: "SUCCESS: " + response.paymentId,
    );

    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      print("current user id");
      print(user.uid);

      final Firestore fireStore = Firestore.instance;
      DateTime expiryDate = DateTime.now().add(Duration(days: 61));
      await fireStore.collection("users").document(user.uid).updateData({
        "subPlan": global.subPlan,
        "subscription": true,
        "expiryDate": expiryDate
      });
      print("updated");
    } catch (e) {
      print(e.toString());
    }

    print("account page");
    razorpay.clear();

    Navigator.pushReplacementNamed(context, '/bottombar');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET: " + response.walletName,
    );
  }

  print('dbbds');
  print("Just came to opencheckout function");
  print(global.uid.toString());
  print(_currentUser.phone.toString());
  // print(global.email);
  var onemonth = {
    'key': 'rzp_live_A94dLEeQb2Cj5s',
    'currency': "INR",
    'amount': 110, //in the smallest currency sub-unit.
    'name': 'Nutshell',
    'description': 'One month Nutshell Extended',
    'prefill': {'contact': '+91' + exphone, 'email': exemail}
  };

  try {
    print("Trying to go to razorpay");
    razorpay.open(onemonth);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  } catch (e) {
    print("catch block ");
    debugPrint(e);
  }
}

void openCheckoutthree(BuildContext context) async {
  print('hiii');
  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('hiiie');
    Fluttertoast.showToast(
      msg: "SUCCESS: " + response.paymentId,
    );

    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      print("current user id");
      print(user.uid);

      final Firestore fireStore = Firestore.instance;
      DateTime expiryDate = DateTime.now().add(Duration(days: 183));
      await fireStore.collection("users").document(user.uid).updateData({
        "subPlan": global.subPlan,
        "subscription": true,
        "expiryDate": expiryDate
      });
      print("updated");
    } catch (e) {
      print(e.toString());
    }

    print("account page");
    razorpay.clear();

    Navigator.pushReplacementNamed(context, '/bottombar');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET: " + response.walletName,
    );
  }

  print("Just came to checkout3 function");
  var threemonths = {
    'key': 'rzp_live_A94dLEeQb2Cj5s',
    'currency': "INR",
    'amount': 120, //in the smallest currency sub-unit.
    'name': 'Nutshell',
    'description': 'Nutshell Extended',
    'prefill': {'contact': '+91' + exphone, 'email': exemail}
  };
  try {
    print("Trying to go to razorpay");
    razorpay.open(threemonths);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  } catch (e) {
    print("catch block ");
    debugPrint(e);
  }
}

void openCheckoutyear(BuildContext context) async {
  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
      msg: "SUCCESS: " + response.paymentId,
    );

    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      print("current user id");
      print(user.uid);

      final Firestore fireStore = Firestore.instance;
      DateTime expiryDate = DateTime.now().add(Duration(days: 365));
      await fireStore.collection("users").document(user.uid).updateData({
        "subPlan": global.subPlan,
        "subscription": true,
        "extendPlan": expiryDate
      });
      print("updated");
    } catch (e) {
      print(e.toString());
    }

    print("account page");
    razorpay.clear();

    Navigator.pushReplacementNamed(context, '/bottombar');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET: " + response.walletName,
    );
  }

  print("Just came to checkoutyear function");
  var oneyear = {
    'key': 'rzp_live_A94dLEeQb2Cj5s',
    'currency': "INR",
    'amount': 130, //in the smallest currency sub-unit.
    'name': 'Nutshell',
    'description': 'Nutshell Extended',
    'prefill': {'contact': '+91' + exphone, 'email': exemail}
  };
  try {
    print("Trying to go to razorpay");
    razorpay.open(oneyear);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  } catch (e) {
    print("catch block ");
    debugPrint(e);
  }
}

void openCheckoutweek(BuildContext context) async {
  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
      msg: "SUCCESS: " + response.paymentId,
    );

    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      print("current user id");
      print(user.uid);

      final Firestore fireStore = Firestore.instance;

      await fireStore
          .collection("users")
          .document(user.uid)
          .updateData({"subPlan": global.subPlan, "subscription": true});
      print("updated");
    } catch (e) {
      print(e.toString());
    }

    print("account page");
    razorpay.clear();

    Navigator.pushReplacementNamed(context, '/bottombar');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET: " + response.walletName,
    );
  }

  print("Just came to checkout functionfds");
  print(global.phone + 'vh');
  var oneweek = {
    'key': 'rzp_live_A94dLEeQb2Cj5s',
    'currency': "INR",
    'amount': 00, //in the smallest currency sub-unit.
    'name': 'Nutshell',
    'description': 'Nutshell Extended',
    'prefill': {
      'contact': '+91' + _currentUser.phone,
      'email': _currentUser.email
    }
  };
  try {
    print("Trying to go to razorpay");
  } catch (e) {
    print("catch block ");
    debugPrint(e);
  }
}

void _handlePaymentError(PaymentFailureResponse response) {
  Fluttertoast.showToast(
    msg: "ERROR: " + response.code.toString() + " - " + response.message,
  );
}

void _handleExternalWallet(ExternalWalletResponse response) {
  Fluttertoast.showToast(
    msg: "EXTERNAL_WALLET: " + response.walletName,
  );
}
