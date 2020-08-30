import 'package:firebase_auth/firebase_auth.dart';

import './paperBack/topic.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nutshell/bottomNav.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutshell/model/userdetails.dart';
import 'package:provider/provider.dart';

class Paperbacks extends StatefulWidget {
  @override
  _PaperbacksState createState() => _PaperbacksState();
}

class _PaperbacksState extends State<Paperbacks> {
  @override
  int count;
  List<DocumentSnapshot> paper = List<DocumentSnapshot>();
  void refresh() async{
          FirebaseUser user = await FirebaseAuth.instance.currentUser();

    final _firestore = Firestore.instance;
    DocumentSnapshot _docSnap =
        await _firestore.collection("users").document(user.uid).get();

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
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentBackPressTime;

    count = Provider.of<UserDetails>(context).noOfPaper;

    paper.addAll(
        Provider.of<UserDetails>(context).qs.documents.sublist(0, count));

    final widget = CarouselSlider(
      options: CarouselOptions(
        enlargeCenterPage: true,
        autoPlay: false,
        pauseAutoPlayOnTouch: true,
        height: MediaQuery.of(context).size.height * 0.8,
      ),
      items: paper.map((back) {
        return Builder(
          builder: (BuildContext context) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      child: GestureDetector(
                          child: CachedNetworkImage(
                            imageUrl: back.data["img"],
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                          onTap: () {
                            Provider.of<UserDetails>(context, listen: false)
                                .onPaperTap(back);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Topic(),
                                ));
                          })),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text(back.data["title"], style: TextStyle(fontSize: 20)),
                )
              ],
            );
          },
        );
      }).toList(),
    );

    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Exit"),
                  content: Text("Are you sure you want to exit?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("YES"),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    ),
                    FlatButton(
                      child: Text("NO"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 50, 10, 10),
              child: widget,
            ),
          ),
        ),
      ),
    );
  }
}
