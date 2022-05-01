import 'dart:async';

import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/authentication/login.dart';
import 'package:cloudyml_app2/authentication/onboard.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/offline/offline_videos.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    showNoInternet() {
      AlertDialog alert = AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.signal_wifi_connected_no_internet_4_rounded,
                    color: Colors.red,
                    size: 70,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.bounceInOut,
                                      type: PageTransitionType.rightToLeft,
                                      child: VideoScreenOffline()),
                                  (route) => false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: gradient),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  'Go offline',
                                  style: TextStyle(
                                      fontFamily: 'SemiBold',
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );

      // show the dialog
      showDialog(
        barrierColor: Colors.black38,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    final StreamSubscription<InternetConnectionStatus> listener =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            print('Data connection is available.');
            //showToast("You're now connected");
            break;
          case InternetConnectionStatus.disconnected:
            print('You are disconnected from the internet.');
            showNoInternet();
            showToast("You are disconnected from the internet");
            break;
        }
      },
    );
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: StyledToast(
        locale: const Locale('en', 'US'),
        textStyle: TextStyle(
            fontSize: 16.0, color: Colors.white, fontFamily: 'Medium'),
        backgroundColor: Colors.black,
        borderRadius: BorderRadius.circular(30.0),
        textPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
        toastAnimation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        startOffset: Offset(0.0, 3.0),
        reverseEndOffset: Offset(0.0, 3.0),
        duration: Duration(seconds: 3),
        animDuration: Duration(milliseconds: 500),
        alignment: Alignment.center,
        toastPositions: StyledToastPosition.bottom,
        curve: Curves.bounceIn,
        reverseCurve: Curves.bounceOut,
        dismissOtherOnShow: true,
        fullWidth: false,
        isHideKeyboard: false,
        isIgnoring: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CloudyML',
          builder: (BuildContext context, Widget? widget) {
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
              return Container();
            };
            return widget!;
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Authenticate(),
        ),
      ),
    );
  }
}
