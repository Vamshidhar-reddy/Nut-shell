import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutshell/ColorAndFonts/Colors.dart';
import 'package:nutshell/bottomNav.dart';
import 'Posts.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<Posts> postsList = [];
  List<DocumentSnapshot> posts = [];

  bool isLoad = false;
  @override
  void initState() {
    super.initState();
    getPost();
  }

  getPost() async {
    setState(() {
      isLoad = true;
    });
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot _docSnap =
        await _firestore.collection("users").document(user.uid).get();

    QuerySnapshot post = await Firestore.instance
        .collection("newsGroup" + _docSnap.data['group'])
        .orderBy("timestamp", descending: true)
        .getDocuments();
    post.documents.isNotEmpty ? posts.addAll(post.documents) : posts = [];
    // print(posts.length);
    // print(posts[0].data["time"]);
    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: isLoad
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(child: new CircularProgressIndicator()),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: new PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: posts.length,
                      itemBuilder: (_, index) {
                        return postsUi(
                          posts[index]["img"],
                          posts[index]["title"],
                          posts[index]["date"],
                          posts[index]["time"],
                          posts[index]["desc"],
                          posts[index]["category"],
                        );
                      }),
                )),
    );
  }

  Widget postsUi(String postImage, String title, String date, String time,
      String description, String category) {
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Material(
        elevation: 15.0,
        child: new Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 7.0,
                ),
              ],
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0)),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: new Image.network(postImage.toString(),
                            fit: BoxFit.cover)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          color: Colors.black54,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              category,
                              style: Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.black54,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              date,
                              style: Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  child: Opacity(
                    opacity: 1.0,
                    child: Container(
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 85,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0,
                                    left: 10.0,
                                    right: 10.0,
                                    bottom: 0.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 0,
                                      right: 8.0,
                                      bottom: 0),
                                  child: new Text(
                                    title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: Center(
                    child: new Text(
                      description,
                      style: TextStyle(
                          color: Colors.black, fontSize: 20, height: 1.4),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                // Spacer(),

                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Divider(
                //     thickness: 3,
                //   ),
                // )
              ],
            )),
      ),
    );
  }
}
