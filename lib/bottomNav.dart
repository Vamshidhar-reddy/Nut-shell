import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutshell/ColorAndFonts/Colors.dart';
import 'package:nutshell/database.dart';
import 'package:nutshell/paperback.dart';
import 'package:nutshell/news.dart';
import 'package:nutshell/paperback.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutshell/users.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'account.dart';
import 'google.dart';
import 'login.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key key}) : super(key: key);
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  var anotherDt;
  Users _currentUser = Users();
  FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedItem = 0;
  static List<Widget> _navScreens = <Widget>[Paperbacks(), News(), Account()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  @override
  void initState() {
    super.initState();
    checkSubscription();
  }

  Future<String> checkSubscription() async {
    try {
      FirebaseUser _firebaseUser = await _auth.currentUser();
      if (_firebaseUser != null) {
        _currentUser = await OurDatabase().getUserInfo(_firebaseUser.uid);
        Timestamp fTs = _currentUser.expiryDate;
        DateTime fDt = fTs.toDate();
        DateTime current = DateTime.now();
        var diff = fDt.difference(current);
        if (diff.inDays <= 0) {
          return showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => new Dialog(
                    child: WillPopScope(
                        child: Container(
                            margin: EdgeInsets.all(10),
                            // width: MediaQuery.of(context).size.width*0.7,
                            child: IntrinsicHeight(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: 95, minWidth: 200),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Your Plan has been Expired,Please extend your Plan to continue the Services',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    // actions:<Widget>[]
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/extendplan');
                                          },
                                          child: Text(
                                            'Extend',
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Color.fromRGBO(
                                                  109, 0, 109, 1),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            signOutGoogle();
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            LoginScreen()),
                                                    (_) => false);
                                          },
                                          child: Text(
                                            'Logout',
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Color.fromRGBO(
                                                  109, 0, 109, 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )),
                        onWillPop: () => SystemNavigator.pop()),
                  ));
          // showDialog(
          //     barrierDismissible: false,
          //     context: context,
          //     builder: (_) => new Dialog(
          //             child: WillPopScope(
          //           onWillPop: () {
          //             SystemNavigator.pop();
          //           },
          //           child: new Container(
          //               decoration: BoxDecoration(
          //                   image: DecorationImage(
          //                       image: AssetImage('assets/image/details.png'),
          //                       fit: BoxFit.fill)),
          //               alignment: FractionalOffset.center,
          //               height: MediaQuery.of(context).size.height * 0.22,
          //               width: MediaQuery.of(context).size.width * 0.65,
          //               padding: const EdgeInsets.all(20.0),
          //               child: new Column(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     'Your Plan has been Expired \nPlease Extend Your Plan to \n Continue Services',
          //                   ),
          //                   SizedBox(
          //                     height: 15.0,
          //                   ),
          //                   Row(
          //                     mainAxisAlignment: MainAxisAlignment.end,
          //                     children: [
          //                       FlatButton(
          //                         onPressed: () {
          //                           Navigator.pushNamed(context, '/extendplan');
          //                         },
          //                         child: Text(
          //                           'Extend',
          //                           style: TextStyle(
          //                             color: Color.fromRGBO(109, 0, 109, 1),
          //                           ),
          //                         ),
          //                       ),

          //                     ],
          //                   )
          //                 ],
          //               )),
          //         )));
        }
        // print(diff.inDays);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _navScreens.elementAt(_selectedItem),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mainColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/paperbackicon.svg",
              fit: BoxFit.contain,
              // color:Colors.red,
              height: 40,
            ),
            // Icon(Icons.book),
            title: Text('Paperbacks'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/newsicon.svg",
              fit: BoxFit.contain,
              // color:Colors.red,
              height: 40,
            ),
            title: Text('News'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/accounticon.svg",
              fit: BoxFit.contain,
              // color:Colors.red,
              height: 40,
            ),
            title: Text('Account'),
          ),
        ],
        currentIndex: _selectedItem,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
