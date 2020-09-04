import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nutshell/orderConfirmation.dart';
import 'package:nutshell/users.dart';
import './paperback.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'database.dart';
import 'ColorAndFonts/Colors.dart';
import 'global.dart' as global;
import 'AccountModule.dart/contactUs.dart';
import 'AccountModule.dart/pricing.dart';
import 'AccountModule.dart/privacy.dart';
import 'AccountModule.dart/refund.dart';
import 'AccountModule.dart/termsandconditions.dart';
import 'editprofilescreen.dart';
import 'account.dart';
import 'AccountModule.dart/aboutUs.dart';
import 'orderConfirmation.dart';
import 'AccountModule.dart/help.dart';

String phone;
String email;

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool btn_enable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/details.png'),
                      fit: BoxFit.fill)),
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Image(
                        fit: BoxFit.fill,
                        image: mainLogo,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    'My Name is',
                    style: TextStyle(
                        fontSize: headings,
                        color: mainColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  TextFormField(
                    autovalidate: true,
                    validator: (String txt) {
                      if (txt.length >= 3) {
                        Future.delayed(Duration.zero).then((_) {
                          setState(() {
                            btn_enable = true;
                            global.name = txt;
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
                    decoration: InputDecoration(
                        focusColor: mainColor,
                        hintText: 'Enter Your Name',
                        hintStyle: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: RaisedButton(
                      color: mainColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: headings,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onPressed: btn_enable == true
                          ? () {
                              Navigator.of(context).pushNamed('/email');
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  bool btn_enable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/details.png'),
                    fit: BoxFit.fill)),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Image(
                      image: mainLogo,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  global.isGLogin ? 'My Phone is' : 'My Email is ',
                  style: TextStyle(
                      fontSize: headings,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                TextFormField(
                  autovalidate: true,
                  validator: (String txt) {
                    if (global.isGLogin) {
                      if (txt.length == 10)
                        Future.delayed(Duration.zero).then((_) {
                          setState(() {
                            btn_enable = true;
                            global.phone = txt;
                          });
                        });
                    } else if (txt.length >= 6) {
                      Future.delayed(Duration.zero).then((_) {
                        setState(() {
                          btn_enable = true;
                          global.email = txt;
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
                  keyboardType: global.isGLogin
                      ? TextInputType.number
                      : TextInputType.emailAddress,
                  decoration: InputDecoration(
                      focusColor: mainColor,
                      hintText: global.isGLogin
                          ? 'Enter Your Phone'
                          : 'Enter Your Email',
                      hintStyle: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: RaisedButton(
                      color: mainColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: headings,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      // padding: EdgeInsets.fromLTRB(180.0, 15.0, 190.0, 15.0),
                      onPressed: btn_enable == true
                          ? () {
                              Navigator.of(context).pushNamed('/birth');
                            }
                          : null),
                ),
              ],
            ),
          )
        ]));
  }
}

class BirthDay extends StatefulWidget {
  @override
  _BirthDayState createState() => _BirthDayState();
}

class _BirthDayState extends State<BirthDay> {
  bool btn_enable = false;
  String birthDateInString;
  DateTime birthDate;
  bool isDateSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/details.png'),
                    fit: BoxFit.fill)),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Image(
                      fit: BoxFit.fill,
                      image: mainLogo,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  'My birthday is',
                  style: TextStyle(
                      fontSize: headings,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        Text(
                          birthDateInString == null
                              ? 'DD/MM/YYYY     '
                              : "   " + birthDateInString + "  ",
                          style: TextStyle(
                              fontSize: 35.0, fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: mainColor,
                          size: 45.0,
                        )
                      ],
                    ),
                    onTap: () async {
                      final datePick = await showDatePicker(
                          context: context,
                          initialDate: new DateTime(1999, 06, 25),
                          firstDate: new DateTime(1970),
                          lastDate: new DateTime(2013));
                      if (datePick != null && datePick != birthDate) {
                        setState(() {
                          birthDate = datePick;
                          isDateSelected = true;
                          birthDateInString =
                              "${birthDate.month}/${birthDate.day}/${birthDate.year}"; // 08/14/2019
                          global.dob = birthDateInString;
                        });
                      }

                      setState(() {
                        btn_enable = true;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: RaisedButton(
                      color: mainColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onPressed: btn_enable == true
                          ? () {
                              Navigator.of(context).pushNamed('/instution');
                            }
                          : null),
                ),
              ],
            ),
          )
        ]));
  }
}

class Instution extends StatefulWidget {
  @override
  _InstutionState createState() => _InstutionState();
}

class _InstutionState extends State<Instution> {
  bool btn_enable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/details.png'),
                    fit: BoxFit.fill)),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Image(
                      fit: BoxFit.fill,
                      image: mainLogo,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  'My Institution is',
                  style: TextStyle(
                      fontSize: headings,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                TextFormField(
                  autovalidate: true,
                  validator: (String txt) {
                    if (txt.length >= 3) {
                      Future.delayed(Duration.zero).then((_) {
                        setState(() {
                          btn_enable = true;
                          global.ins = txt;
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
                  decoration: InputDecoration(
                      hintText: 'The name of the institution you are in',
                      hintStyle:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: RaisedButton(
                      color: mainColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onPressed: btn_enable == true
                          ? () {
                              Navigator.of(context).pushNamed('/pincode');
                            }
                          : null),
                ),
              ],
            ),
          )
        ]));
  }
}

class PinCode extends StatefulWidget {
  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {
  String pinCode;
  bool _isLoading = false;
  bool btn_enable = false;

  Geolocator geolocator = Geolocator();

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    Position userLocation;

    void callMe(Position userLocation) async {
      print("called for pLacemark");
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
          userLocation.latitude, userLocation.longitude);

      print(placemark[0].postalCode);
      setState(() {
        pinCode = placemark[0].postalCode;
        global.pincode = pinCode;
        btn_enable = true;
        _isLoading = false;
      });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/details.png'),
                    fit: BoxFit.fill)),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Image(
                      fit: BoxFit.fill,
                      image: mainLogo,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  'My Pincode is',
                  style: TextStyle(
                      fontSize: headings,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextFormField(
                            // autovalidate: true,
                            maxLength: 6,
                            maxLengthEnforced: true,
                            onChanged: (String txt) {
                              if (txt.length == 6) {
                                Future.delayed(Duration.zero).then((_) {
                                  setState(() {
                                    btn_enable = true;
                                    global.pincode = txt;
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
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                counterText: '  ',
                                hintText: pinCode != null ? pinCode : "",
                                labelText: pinCode == null
                                    ? ' Pincode of your location'
                                    : pinCode),
                            // validator: validateCity,
                            onSaved: (String value) {
                              pinCode = value;
                            }),
                      ),
                      InkWell(
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : SizedBox(
                                // width: MediaQuery.of(context).size.width * 0.20,
                                child: Row(
                                children: <Widget>[
                                  // Text(" Or Autolocate "),
                                  Icon(
                                    Icons.my_location,
                                    color: Color.fromRGBO(109, 0, 109, 1),

                                    size: 40,
                                    //  my_location
                                  ),
                                ],
                              )),
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          _getLocation().then((value) {
                            setState(() {
                              // isLoading=true;
                              btn_enable = true;
                              userLocation = value;
                            });
                            // await
                            callMe(userLocation);
                          });
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: RaisedButton(
                      color: mainColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onPressed: btn_enable == true
                          ? () {
                              print("clik");

                              Navigator.pushNamed(context, "/group");
                            }
                          : null),
                ),
              ],
            ),
          )
        ]));
  }
}

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await precachePicture(
          ExactAssetPicture(
              SvgPicture.svgStringDecoder, 'assets/images/GroupA.svg'),
          context);
      await precachePicture(
          ExactAssetPicture(
              SvgPicture.svgStringDecoder, 'assets/images/GroupB.svg'),
          context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/details.png'),
                    fit: BoxFit.fill)),
            padding: EdgeInsets.only(
                left: 20.0, top: 10.0, bottom: 10.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.6,
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
                  'My Group is',
                  style: TextStyle(
                    fontSize: headings,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    splashColor: Colors.white,
                    onPressed: () {
                      global.group = "A";
                      OurDatabase().createUser();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderConfirmation()));
                    },
                    child: SvgPicture.asset('assets/images/GroupB.svg'),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    splashColor: Colors.white,
                    onPressed: () {
                      global.group = "B";
                      OurDatabase().createUser();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderConfirmation()));
                    },
                    child: SvgPicture.asset('assets/images/GroupA.svg'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
