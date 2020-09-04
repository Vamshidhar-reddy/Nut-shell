import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nutshell/bottomNav.dart';
import 'package:nutshell/paperback.dart';
import 'package:provider/provider.dart';

import 'cover.dart';
import '../model/userdetails.dart';

class Topic extends StatefulWidget {
  @override
  _TopicState createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  DocumentSnapshot topic, topicDoc;
  QuerySnapshot qs;
  bool _isTopic = false;
  String grp;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      topic = Provider.of<UserDetails>(context, listen: false).doc;
    });
    getTopicsDoc();
  }

  void getTopicsDoc() async {
    setState(() {
      _isTopic = true;
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
      topic = Provider.of<UserDetails>(context, listen: false).doc;

    final _firestore = Firestore.instance;
    DocumentSnapshot _docSnap =
        await _firestore.collection("users").document(user.uid).get();
     qs = await _firestore
        .collection(
            "Group" + _docSnap.data["group"] + "/${topic.documentID}/Topics")
        .orderBy("number")
        .getDocuments();
    setState(() {
      _isTopic = false;
    });
    Provider.of<UserDetails>(context, listen: false).topicDocs(qs.documents);
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        excludeHeaderSemantics: true,
        titleSpacing: 0,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () =>
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return BottomBar();
                  },
                ))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return BottomBar();
            },
          ));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Text("Topics",
                      style: TextStyle(color: Colors.black, fontSize: 25)),
                ),
              ),
              _isTopic
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<UserDetails>(builder: (context, obj, _) {
                      return Expanded(
                        child: obj.topicDoc.length == 0
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Comming",
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 25),
                                    ),
                                    Text(
                                      "Soon",
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 25),
                                    )
                                  ],
                                ),
                              )
                            : GridView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: obj.topicDoc.length,
                                itemBuilder: (context, i) {
                                  return Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Provider.of<UserDetails>(context,
                                                listen: false)
                                            .topicDocs(obj.topicDoc);
                                        Provider.of<UserDetails>(context,
                                                listen: false)
                                            .topicTap(i);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return Cover();
                                          },
                                        ));
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation: 4.0,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: GridTile(
                                                  child: CachedNetworkImage(
                                                    imageUrl: obj.topicDoc[i]
                                                        .data["img"],
                                                    fit: BoxFit.fill,
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (_, str, dynamic) =>
                                                            Center(
                                                      child: Icon(Icons.error),
                                                    ),
                                                  ),
                                                  // ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                              child: Text(
                                                  obj.topicDoc[i].data["title"],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.6,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                              ),
                      );
                    })
            ],
          ),
        ),
      ),
    );
    // return
  }
}
