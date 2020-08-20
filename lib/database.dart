import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutshell/users.dart';
import 'global.dart' as global;

class OurDatabase {
  final Firestore _firestore = Firestore.instance;

  Future<String> createUser() async {
    String retVal = "error";
    FirebaseUser uid = await FirebaseAuth.instance.currentUser();
    var now = DateTime.now();

    try {
      await _firestore.collection("users").document(uid.uid).setData({
        'first Name': global.name,
        'email': global.email,
        'school': global.ins,
        'DOB': global.dob,
        'subscription': false,
        'phone': global.phone,
        'group': global.group,
        'accountCreated': Timestamp.now(),
        'photoUrl': global.photoUrl,
        'pinCode': global.pincode,
        'subPlan': global.subPlan,
        'expiryDate': global.expiryDate
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<Users> getUserInfo(String uid) async {
    Users retVal = Users();

    try {
      print("called for data");
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("users").document(uid).get();
      print("waiting jp");
      print(retVal.fname = _docSnapshot.data["first Name"]);
      retVal.accountCreated = _docSnapshot.data["accountCreated"];
      retVal.expiryDate = _docSnapshot.data["expiryDate"];

      retVal.uid = uid;
      retVal.sID = _docSnapshot.data["OrderId"];
      retVal.fname = _docSnapshot.data["first Name"];
      // // retVal.lname = _docSnapshot.data["Last Name"];
      retVal.email = _docSnapshot.data["email"];
      retVal.school = _docSnapshot.data["school"];
      // // retVal.grade = _docSnapshot.data["class"];
      // // retVal.city = _docSnapshot.data["City"];
      retVal.phone = _docSnapshot.data["phone"];
      retVal.group = _docSnapshot.data["group"];
      // retVal.accountCreated = _docSnapshot.data["accountCreated"];
      retVal.photoUrl = _docSnapshot.data["photoUrl"];
      retVal.subPlan = _docSnapshot.data["subPlan"];
      retVal.pinCode = _docSnapshot.data["pinCode"];
      // global.timeCreated = _docSnapshot.data["accountCreated"];
      print("jp");
      print(retVal.accountCreated);
      print(retVal.expiryDate);
      // print(global.timeCreated.day.toString());
    } catch (e) {
      print("in catch");
      print(e);
    }
    return retVal;
  }

  Future<String> freesubscription(String uid) async {
    String retVal = "error";

    try {
      await _firestore.collection("Subscribed").document(uid).setData({
        'OrderID': uid,
        'accountCreated': DateTime.now(),
      });
      print("Uploaded subscribed Info successfully in Firebase");
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  void updateDetails(Users currentUser) async {
    print("called for updating info");
    var _now = DateTime.now();
    try {
      await _firestore
          .collection("users")
          .document(currentUser.uid)
          .updateData({
        'first Name': currentUser.fname,
        'email': currentUser.email,
        'school': currentUser.school,
        'phone': currentUser.phone,
        'accountCreated': _now
      });
      print("Updated Info successfully in Firebase");
    } catch (e) {
      print(e);
    }
  }
}
