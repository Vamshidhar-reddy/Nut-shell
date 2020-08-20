import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:nutshell/database.dart';
import 'package:nutshell/global.dart' as global;
import 'package:nutshell/google.dart';
import 'package:nutshell/login.dart';
import 'package:nutshell/users.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'google.dart';
import 'database.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

File _image;
final picker = ImagePicker();
String _myValue;
String _description;
String postUrl;
String cardUrl;
String _category;
String _group;
bool uploadPic = false;
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _AccountState extends State<Account> {
  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future uploadPic() async {
    final StorageReference postImageRef =
        FirebaseStorage.instance.ref().child("profile");

    var timeKey = new DateTime.now();

    final StorageUploadTask uploadTask =
        postImageRef.child(timeKey.toString() + ".png").putFile(_image);
    var PostUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    String postUrl = PostUrl.toString();
    print("Post Url =" + postUrl);
    saveToDatabase(postUrl);
    // var user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection('users')
        .document(_currentUser.uid)
        .updateData({'photoUrl': postUrl});

    setState(() {
      _currentUser.photoUrl = postUrl;

      print("Profile Picture uploaded");
      print('xy');
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  void saveToDatabase(String url) {
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "postImage": postUrl,
      "title": _myValue,
      "date": date,
      "time": time,
      "description": _description,
      "category": _category,
    };
    ref.child("profile").push().set(data);
  }

  getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    _cropImage(image);

    setState(() {
      _image = File(image.path);
      // _cropImage(image);
      print('Image Path $_image');
    });
    // uploadPic();
  }

  _cropImage(PickedFile image) async {
    // var image;
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
    if (croppedImage != null) {
      _image = croppedImage;
      setState(() {});
    }
    uploadPic();
  }

  Users _currentUser = Users();

  Users get getCurrentUser => _currentUser;

  bool isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> onStartUp() async {
    String retVal = "error";

    try {
      setState(() {
        isLoading = true;
      });
      FirebaseUser _firebaseUser = await _auth.currentUser();
      // print(_firebaseUser.email);
      if (_firebaseUser != null) {
        // print(_firebaseUser.uid);
        _currentUser = await OurDatabase().getUserInfo(_firebaseUser.uid);
        if (_currentUser != null) {
          retVal = "success";
          setState(() {
            isLoading = false;
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
    // TODO: implement initState
    super.initState();
    onStartUp();
  }

  @override
  Widget build(BuildContext context) {
    Alert(BuildContext context) {
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return new AlertDialog(
              // elevation: 200.0,
              backgroundColor: Colors.transparent,
              titlePadding: EdgeInsets.all(20.0),

              actions: <Widget>[
                Container(
                  height: (MediaQuery.of(context).size.height - 50) * 0.8,
                  width: (MediaQuery.of(context).size.height) * 0.8,
                  // MediaQuery.of(context).size.width *0.8,
                  child: PhotoView(
                      imageProvider:
                          NetworkImage(_currentUser.photoUrl.toString()),
                      // tightMode: true,
                      maxScale: 2.2,
                      filterQuality: FilterQuality.high,
                      minScale: 0.5,
                      backgroundDecoration: BoxDecoration(
                        color: Colors.transparent,
                      )),
                )
              ],
            );
          });
    }

    // print("jp"+_currentUser.photoUrl.toString());
    return WillPopScope(
        onWillPop: () {
          Navigator.pushNamed(context, "/bottombar");
        },
        child: Scaffold(
            backgroundColor: Colors.white,

            // bottomNavigationBar: bottomBar(context, 2),
            // bottomNavigationBar: BottomBar(),

            // bottomNavigationBar: PersistentNavBar(),
            appBar: new AppBar(
              leading: new IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 30.0,
                  color: Colors.black,
                ),
                tooltip: 'back',
                onPressed: () {
                  Navigator.pushNamed(context, "/bottombar");
                },
              ),
              // title: Text(
              //   'Account',
              //   style: TextStyle(color: Colors.black, fontSize: 30.0),
              // ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/editprofile");
                    },
                    child: Text('Edit\nProfile',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w900,
                        ))),
              ],
              // title: new Text("Account Details",style: TextStyle(color:Colors.black,fontSize: 30.0),),
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: _currentUser.photoUrl == null
                                  ? Icon(Icons.account_circle, size: 120.0)
                                  : GestureDetector(
                                      onTap: () => Alert(context),
                                      child: isLoading == true
                                          ? CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            )
                                          : CircleAvatar(
                                              radius: 70,
                                              backgroundColor: Colors.white,
                                              backgroundImage: NetworkImage(
                                                  _currentUser.photoUrl
                                                      .toString()),
                                            ),
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 60.0),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    size: 30.0,
                                  ),
                                  onPressed: () => getImage()),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.10,
                              width: MediaQuery.of(context).size.width * 0.40,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        _currentUser.fname.toString() + " ",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.blue,
                                        size: 20.0,
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 3.0,
                                    color: Colors.redAccent,
                                    endIndent: 3.0,
                                  ),
                                  Text(
                                    "Group:\t\t" +
                                        _currentUser.group.toString(),
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider(
                          height: 45,
                          thickness: 2.0,
                          color: Color.fromRGBO(109, 0, 109, 1),
                        ),
                        Container(
                          padding: new EdgeInsets.all(5.0),
                        ),
                        SizedBox(
                            child: Column(children: <Widget>[
                          ListTile(
                            title: new Text('Pricing Plan',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            leading: new Icon(Icons.account_balance_wallet),
                            onTap: () {
                              Navigator.pushNamed(context, "/pricing");
                            },
                          ),
                          ListTile(
                            title: new Text('Contact Us',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            leading: new Icon(Icons.call),
                            onTap: () {
                              Navigator.pushNamed(context, "/contact");
                            },
                          ),
                          ListTile(
                            title: new Text('About Us',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            leading: new Icon(Icons.chat_bubble_outline),
                            onTap: () {
                              Navigator.pushNamed(context, "/aboutUs");
                            },
                          ),
                          ListTile(
                            title: new Text('Help',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            leading: new Icon(Icons.assignment),
                            subtitle: Text("Privacy, Refund, TnC"),
                            onTap: () {
                              Navigator.pushNamed(context, "/help");
                            },
                          ),
                          ListTile(
                            title: new Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold
                                  // color:Colors.deepOrange
                                  ),
                            ),
                            leading: new Icon(
                              Icons.settings_power,
                            ),
                            onTap: () {
                              showAlertDialog(context);
                            },
                          ),
                        ])),
                      ],
                    ),
                  )));
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("No"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Yes"),
    onPressed: () {
      signOutGoogle();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => LoginScreen()), (_) => false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Logout",
    ),
    content: Text("Do you want to logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
