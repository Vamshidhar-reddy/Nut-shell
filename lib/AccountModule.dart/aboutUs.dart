import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "About Us",
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
            Image.asset(
              "assets/images/About_us_30.png",
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 1,
              fit: BoxFit.fill,
            ),
            Image.asset(
              "assets/images/About_us_31.png",
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 1,
              fit: BoxFit.fill,
            ),
            Image.asset(
              "assets/images/About_us_32.png",
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 1.25,
              fit: BoxFit.fill,
            ),
            Image.asset(
              "assets/images/About_us_33.png",
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 1,
              fit: BoxFit.fill,
            ),
            Image.asset(
              "assets/images/About_us_34.png",
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 1,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
