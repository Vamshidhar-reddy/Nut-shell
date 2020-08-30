import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
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
                  ),
                )),
    );
  }

  Widget postsUi(String postImage, String title, String date, String time,
      String description, String category) {
    return new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 10.0, right: 10.0, bottom: 0.0),
                      child: new Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    child: new Image.network(postImage.toString(),
                        fit: BoxFit.cover)),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: Row(
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
                            textAlign: TextAlign.center,
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
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: new Text(
                  description,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Divider(
                thickness: 3,
              ),
            )
          ],
        ));
  }
}
