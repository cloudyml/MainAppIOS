import 'dart:async';

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
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

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
      email: email,
      password: password,
    ))
        .user;
    passwordttt = password;
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
    passwordttt = password;
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
  Future googleLogin(
    BuildContext context,
  ) async {
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

      //This is check if User already exist in Database in User Collection
      //If User does not exist create user and groups collection
      await FirebaseFirestore.instance
          .collection('Users')
          //Comparing Google providers email with email as Fields in User collection
          .where('email', isEqualTo: _user?.email)
          .get()
          .then((value) async {
        if (value.docs.isEmpty) {
          userprofile(
            name: _user?.displayName,
            email: _user?.email,
            mobilenumber: '',
            image: _user?.photoUrl,
            authType: "googleAuth",
            phoneVerified: false,
            listOfCourses: [],
          );
          showToast('Account Created');
        }
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1234,
              channelKey: 'image',
              title: 'Welcome to CloudyML',
              body: 'It\'s great to have you on CloudyML',
              bigPicture: 'asset://assets/HomeImage.png',
              largeIcon: 'asset://assets/logo2.png',
              notificationLayout: NotificationLayout.BigPicture,
              displayOnForeground: true),
        );
        await Provider.of<UserProvider>(context, listen: false)
            .addToNotificationP(
          title: 'Welcome to CloudyML',
          body: 'It\'s great to have you on CloudyML',
          notifyImage:
              'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/images%2Fhomeimage.png?alt=media&token=2f4abc37-413f-49c3-b43d-03c02696567e',
          NDate: DateFormat('dd-MM-yyyy | h:mm a').format(DateTime.now()),
        );
      });
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            duration: Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
            type: PageTransitionType.rightToLeftWithFade,
            child: HomePage()),
        (route) => false,
      );
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
            type: PageTransitionType.rightToLeftWithFade,
            child: Onboardew()),
        (route) => false);
  }
}

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  AuthenticationProvider(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      print(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      final displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      final userEmail = '${appleCredential.email}';

      final firebaseUser = authResult.user;
      print(displayName);
      await firebaseUser!.updateDisplayName( displayName);
      await firebaseUser.updateEmail(userEmail);

      return firebaseUser;
    } catch (exception) {
      print(exception);
    }
    // return firebaseUser;
  }
}


void userprofile(
    {String? name,
    var mobilenumber,
    var email,
    var image,
    String? authType,
    bool? phoneVerified,
    List<String?>? listOfCourses}) async {
  await FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set({
    "name": name,
    "mobilenumber": mobilenumber,
    "email": email,
    "paidCourseNames": listOfCourses,
    "authType": authType,
    "phoneVerified": phoneVerified,
    "courseBuyID": "0", //course id will be displayed
    "paid": "False",
    "id": _auth.currentUser!.uid,
    "password": "is it needed",
    "role": "student",
    "couponCodeDetails": {},
    "payInPartsDetails": {},
    "image": image
  });
}