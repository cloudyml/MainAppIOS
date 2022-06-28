import 'dart:async';
import 'package:cloudyml_app2/services/local_notificationservice.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';

import '../authentication/firebase_auth.dart';

class splash extends StatefulWidget {

  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState(){
    // TODO:implement initState
    super.initState();
    //listnerNotifications();
    //gives you the message on which user taps and opens
    //the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    ////foreground notification
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification!=null){
        print(message.notification!.title);
        print(message.notification!.body);
      }
      LocalNotificationService.createanddisplaynotification(message);
    });

    ////app is background but opened and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // String imageUrl = message.notification!.android!.imageUrl??'';
      // _firestore.collection('Notifications')
      //     .add({
      //   'title':message.notification!.title,
      //   'description':message.notification!.body,
      //   'icon':imageUrl
      // });
      final routeFromMessage=message.data["route"];
      print(routeFromMessage);
      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  // StreamSubscription<String?> listnerNotifications(){
  //   return LocalNotificationService.onNotifications.stream.listen(onClickedNotification);
  // }
  // void onClickedNotification(String? payload) {
  //   //dispose();
  //   if(!mounted){
  //     // setState((){
  //       Navigator.of(context).pushNamed('account');
  //     //});
  //   }
  // }

  void pushToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          duration: Duration(milliseconds: 200),
          curve: Curves.bounceInOut,
          type: PageTransitionType.fade,
          child: Authenticate(),
        ),
        (route) => false);
    print('pushedtohome');
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
              Color.fromARGB(255, 158, 2, 148),
              Color.fromARGB(255, 5, 2, 180),
              // Color.fromARGB(255, 3, 193, 218)
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropShadowImage(
              image: Image.asset(
                'assets/DP_png.png',
                width: width * .45,
                height: height * .2,
              ),
              offset: const Offset(3, 8),
              scale: .9,
              blurRadius: 10,
              borderRadius: 0,
            ),
            // SizedBox(height: 1),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 1.5,
                    color: Colors.black,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'CloudyML',
                    textAlign: TextAlign.center,
                    colors: [
                      Colors.white,
                      Color.fromARGB(255, 245, 245, 245),
                      Colors.purple,
                      Color.fromARGB(255, 79, 3, 210),
                      Colors.pinkAccent,
                      Colors.amber,
                      Colors.teal,
                      // Colors.red,
                    ],
                    textStyle: TextStyle(fontSize: 35),
                    speed: Duration(milliseconds: 500),
                    // scalingFactor: 2.0
                  ),
                ],
                pause: Duration(milliseconds: 1500),
                totalRepeatCount: 1,
                isRepeatingAnimation: true,
              ),
            ),
            SizedBox(height: 0),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: AnimatedTextKit(
                  pause: Duration(seconds: 1),
                  animatedTexts: [
                    TyperAnimatedText('#LearnByDoing',
                        textAlign: TextAlign.center,
                        speed: Duration(milliseconds: 200),
                        curve: Curves.bounceInOut),
                  ],
                  totalRepeatCount: 1,
                  isRepeatingAnimation: true,
                  onFinished: () {
                    pushToHome();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
