import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nutshell/AccountModule.dart/extendplan.dart';
import 'package:nutshell/AccountModule.dart/extendplan.dart';
import 'package:nutshell/AccountModule.dart/help.dart';
import 'package:nutshell/bottomNav.dart';
import 'package:nutshell/details.dart';
import 'package:nutshell/dummy.dart';
import 'package:nutshell/global.dart';
import 'package:nutshell/model/userdetails.dart';
import 'package:nutshell/paperback.dart';
import 'package:nutshell/login.dart';
import 'package:nutshell/paperback.dart';
import 'package:nutshell/splashscreen.dart';
import 'package:flutter/services.dart';
import 'package:nutshell/subscription.dart';
import 'package:provider/provider.dart';
import 'AccountModule.dart/contactUs.dart';
import 'AccountModule.dart/pricing.dart';
import 'AccountModule.dart/privacy.dart';
import 'AccountModule.dart/refund.dart';
import 'AccountModule.dart/termsandconditions.dart';
import 'Otp.dart';
import 'editprofilescreen.dart';
import 'account.dart';
import 'AccountModule.dart/aboutUs.dart';
import 'orderConfirmation.dart';
import 'AccountModule.dart/extendorder.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // WidgetsBinding.instance;
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

  runApp(MyApp());
  // WidgetsBinding.instance;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDetails(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/paperback': (BuildContext context) => Paperbacks(),
          '/Login': (BuildContext context) => LoginScreen(),
          '/details': (BuildContext context) => Details(),
          '/subs': (BuildContext context) => Subscription(),
          '/intro': (BuildContext context) => IntroScreen(),
          'otp': (BuildContext context) => Otp(),
          '/dummy': (BuildContext context) => DummyScreen(),
          '/account': (BuildContext context) => Account(),
          '/help': (BuildContext context) => Help(),
          '/contact': (BuildContext context) => ContactUs(),
          '/pricing': (BuildContext context) => Pricing(),
          '/privacy': (BuildContext context) => Privacy(),
          '/refund': (BuildContext context) => Refund(),
          '/termsandconditions': (BuildContext context) => TermsAndConditions(),
          '/editprofile': (BuildContext context) => EditProfileScreen(),
          '/aboutUs': (BuildContext context) => AboutUs(),
          '/orderConfirm': (BuildContext context) => OrderConfirmation(),
          '/bottombar': (BuildContext context) => BottomBar(),
          '/email': (BuildContext context) => new Email(),
          '/birth': (BuildContext context) => new BirthDay(),
          '/instution': (BuildContext context) => new Instution(),
          '/pincode': (BuildContext context) => new PinCode(),
          '/paperback': (BuildContext context) => Paperbacks(),
          '/group': (BuildContext context) => GroupScreen(),
          '/account': (BuildContext context) => Account(),
          '/help': (BuildContext context) => Help(),
          '/contact': (BuildContext context) => ContactUs(),
          '/pricing': (BuildContext context) => Pricing(),
          '/privacy': (BuildContext context) => Privacy(),
          '/refund': (BuildContext context) => Refund(),
          '/termsandconditions': (BuildContext context) => TermsAndConditions(),
          '/editprofile': (BuildContext context) => EditProfileScreen(),
          '/aboutUs': (BuildContext context) => AboutUs(),
          '/extendplan': (BuildContext context) => Extend(),
          '/extendorder': (BuildContext context) => ExtendOrder(),
        },
        title: 'Nutshell',
        theme: ThemeData(
            fontFamily: 'Montserret',
            primarySwatch: Colors.grey,
            textTheme: TextTheme(
                headline1: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                subtitle2: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                subtitle1: TextStyle(fontSize: 20, color: Colors.black))),
        home: Splash(),
      ),
    );
  }
}
