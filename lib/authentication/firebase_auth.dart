import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/authentication/onboardnew.dart';
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

// bool emailsigned=false;
// bool isVerifyy=false;
// ValueNotifier<bool> emailsigned=ValueNotifier(false);
// ValueNotifier<bool> isVerifyy=ValueNotifier(false);
class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return HomePage();
    } else {
      return Onboardew();
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
    passwordttt=password;
    if (user != null) {
      print("Account Created Successful");
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
    passwordttt=password;
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
          MaterialPageRoute(builder: (context) => Onboardew()),
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
      showToast('Please wait while we are fetching info...');
      DocumentSnapshot userDocs = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userDocs.data() == null) {
        userprofile(name: _user?.displayName, email: _user?.email,mobilenumber: '',image:_user?.photoUrl);
        showToast('Account Created');
      }
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              duration: Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              type: PageTransitionType.rightToLeft,
              child: HomePage()),
          (route) => false);
      await AwesomeNotifications().createNotification(
          content:NotificationContent(
              id:  1234,
              channelKey: 'image',
              title: 'Welcome to CloudyML',
              body: 'It\'s great to have you on CloudyML',
              bigPicture: 'asset://assets/HomeImage.png',
              largeIcon: 'asset://assets/logo2.png',
              notificationLayout: NotificationLayout.BigPicture,
              displayOnForeground: true
          )
      );
      await Provider.of<UserProvider>(context, listen: false).addToNotificationP(
          title: 'Welcome to CloudyML',
          body: 'It\'s great to have you on CloudyML',
          notifyImage: 'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/images%2Fhomeimage.png?alt=media&token=2f4abc37-413f-49c3-b43d-03c02696567e'
        //index:
      );

      // showToast('Account Created');

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
            child: Onboardew()),
        (route) => false);
  }
}

void userprofile({String? name, var mobilenumber, var email,var image}) async {
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
    "role": "student",
    "couponCodeDetails": {},
    "payInPartsDetails": {},
    "image":image
  });
}
