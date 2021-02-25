import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nutshell/ColorAndFonts/Colors.dart';
import 'package:nutshell/bottomNav.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Contact US",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30.0,
            color: Colors.black,
          ),
          tooltip: 'back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: ListView(
          children: <Widget>[
            _buildBody(context),
            // Text("\n\n\n No TermsAndConditionss till now",style: TextStyle(fontSize:SizeConfig.blockSizeVertical * 2.5,color: Colors.green),),
          ],
        ),
      ),
    );
  }

  _buildBody(context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Image.asset('assets/images/logo.png',
                fit: BoxFit.fitHeight,
                width: MediaQuery.of(context).size.width * 0.95,
                height: 100),
          ),
          Padding(padding: EdgeInsets.all(10.0)),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              "If you have any questions or feedback, please reach out to us:",
            ),
          ),
          Text("\n"),
          Container(
            // padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "ADDRESS",
                          style: TextStyle(color: mainColor, fontSize: 12),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              " \nQuizzora & Co., 2nd Floor, Basera Apartment, Hill Cart, Road, 13/6 B.M. Saran, Mahananda Para, Near Bata Lane,Siliguri - 734001",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            )),
                      ],
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      _launchMaps("26.7132222", "88.4182002");
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.directions,
                          color: mainColor,
                        ),
                        Text("      ")
                      ],
                    )
                    //
                    )
              ],
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("     PHONE",
                    style: TextStyle(color: mainColor, fontSize: 12)),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("    8617587964",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                InkWell(
                    onTap: () {
                      _LaunchPhone("8617587964");
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.phone,
                          color: mainColor,
                        ),
                        Text("      ")
                      ],
                    ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("    9647837544",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                InkWell(
                    onTap: () {
                      _LaunchPhone("9647837544");
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.phone,
                          color: mainColor,
                        ),
                        Text("      ")
                      ],
                    ))
              ],
            ),
          ),
          Divider(),
          Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("    EMAIL",
                      style: TextStyle(color: mainColor, fontSize: 12)),
                ],
              )),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("    info@mynutshell.in",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            InkWell(
                onTap: () {
                  _launchEmail("info@mynutshell.in");
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.email,
                      color: mainColor,
                    ),
                    Text("      ")
                  ],
                ))
          ])
        ],
      ),
    );
  }

  _LaunchPhone(String number) async {
    String mobileUrl = "tel:${number}";
    if (await canLaunch(mobileUrl)) {
      await launch(mobileUrl);
    } else {}
  }

  _launchEmail(String email) async {
    String mailUrl = "mailto:${email}";
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      // logger.info("Can't open phone");
    }
  }

  _launchMaps(String lat, String lon) async {
    var url = 'https://goo.gl/maps/iqj3KuzYuXy1RcJC9';
    if (Platform.isIOS) {
      // iOS
      url = 'https://goo.gl/maps/iqj3KuzYuXy1RcJC9';
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
