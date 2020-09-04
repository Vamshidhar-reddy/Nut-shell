import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:nutshell/ColorAndFonts/Colors.dart';
import 'package:nutshell/details.dart';
import 'package:nutshell/google.dart';
import 'package:nutshell/paperback.dart';
import 'package:nutshell/phone.dart';
import 'package:nutshell/subscription.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'constants.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
          centerWidget: Center(
              child: SvgPicture.asset("assets/images/INTRO1.svg",
                  height: 350, width: 400, fit: BoxFit.contain)),
          backgroundOpacity: 0.1,
          backgroundImage: 'assets/images/Slider1.png'),
    );
    slides.add(
      new Slide(
          centerWidget: Center(
              child: SvgPicture.asset("assets/images/INTRO2.svg",
                  height: 350, width: 400, fit: BoxFit.contain)),
          backgroundOpacity: 0.1,
          backgroundImage: 'assets/images/Slider2.png'),
    );
    slides.add(
      new Slide(
          centerWidget: Center(
              child: SvgPicture.asset("assets/images/INTRO3.svg",
                  height: 350, width: 400, fit: BoxFit.contain)),
          backgroundOpacity: 0.1,
          backgroundImage: 'assets/images/Slider3.png'),
    );
  }

  void onDonePress() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool checkValue = false;

  Widget _buildPhone(Function onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.width * 0.95,
          child: RaisedButton(
            color: mainColor,
            onPressed: () {
              signInWithGoogle(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset('assets/images/google.png'),
                Text(
                  'Signin with Google',
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
              ],
            ),
            shape: border,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialBtn() {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.95,
        child: RaisedButton(
          color: Colors.white,
          onPressed: () {
            // print("clicked 1");
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new Phone()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Login with Phone',
                style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Icon(
                  Icons.navigate_next,
                  size: 30.0,
                ),
              )
            ],
          ),
          shape: border,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(109, 0, 109, 1),5
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/loginbg.png'),
                fit: BoxFit.fill,
              )),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 60.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Image(
                        fit: BoxFit.fill,
                        image: splashLogo,
                      ),
                    ),
                    // Text('Hello \nThere.',
                    //     style: TextStyle(
                    //         fontSize: 70,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white)),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.015,
                    ),
                    Text('LOGIN',
                        style: TextStyle(
                            color: mainColor,
                            fontSize: headings,
                            fontWeight: FontWeight.w900)),
                    SizedBox(
                      height: 20,
                    ),
                    Center(child: _buildSocialBtn()),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    _buildPhone(() => Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) => new Phone()))),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
