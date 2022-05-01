import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/authentication/email_signup.dart';
import 'package:cloudyml_app2/authentication/login.dart';
import 'package:cloudyml_app2/authentication/onboard.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String? gname;
String? gemail;
String? gimageUrl;

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return HomePage();
    } else {
      return OnBoard();
    }
  }
}

Future<User?> createAccount(
    String email, String password, String text, BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("Account Created Successful");
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => DetailsScreen()));
      return user;
    } else {
      print("Account Creation Failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      print("Login Successful");
      return user;
    } else {
      print("Login Failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    try {
      final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      provider.googlelogout(context);
    } catch (e) {
      await _auth.signOut().then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBoard()),
        );
      });
    }
  } catch (e) {
    print("error");
  }
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin(context) async {
    try {
      final googleUser = await googleSignIn.signIn();
      showToast('Please wait while we are fetching info...');
      if (googleUser == null) return;
      _user = googleUser;
      print('user...');
      print(_user);
      final googleAuth = await googleUser.authentication;
      print("this is goooogle-- $googleAuth");
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print(googleAuth.idToken);
      print("Printing Access Token.........");
      print(googleAuth.accessToken);
      print("Printed");
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              duration: Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              type: PageTransitionType.rightToLeft,
              child: DetailsScreen()),
          (route) => false);

      showToast('Account Created');

      return true;
    } catch (e) {
      print(e.toString());
      showToast(e.toString());
      return false;
    }
  }

  Future googlelogout(context) async {
    try {
      await googleSignIn.disconnect();
    } catch (e) {
      print(e);
    }
    FirebaseAuth.instance.signOut();
    showToast('Logged out');
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            duration: Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
            type: PageTransitionType.rightToLeft,
            child: OnBoard()),
        (route) => false);
  }
}

void userprofile(String name, var mobilenumber, var email) async {
  await FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set({
    "name": name,
    "mobilenumber": mobilenumber,
    "email": email,
    "paidCourseNames": [],
    "courseBuyID": "0", //course id will be displayed
    "paid": "False",
    "id": _auth.currentUser!.uid,
    "password": "is it needed",
    "role": "student"
  });
}
