import 'package:cloudyml_app2/authentication/email_signup.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/authentication/login.dart';
import 'package:cloudyml_app2/authentication/phone_auth.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  bool? googleloading = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(gradient: gradient),
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 18,
              ),
              Image.asset(
                'assets/logo2.png',
                height: 70,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Welcome',
                style: TextStyle(
                    fontFamily: 'Bold', fontSize: 40, color: Colors.white),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Learn Data Science and ML on the go with our mobile app ',
                style: TextStyle(
                    fontFamily: 'Medium',
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7)),
              ),
              SizedBox(
                height: height * 0.07,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.bounceInOut,
                        type: PageTransitionType.rightToLeft,
                        child: Login()),
                  );
                },
                child: Container(
                  height: 50,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 2)),
                  child: Center(
                    child: Text(
                      'Continue with Email',
                      style:
                          TextStyle(fontFamily: 'Medium', color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.bounceInOut,
                        type: PageTransitionType.rightToLeft,
                        child: PhoneAuth()),
                  );
                },
                child: Container(
                  height: 50,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 2)),
                  child: Center(
                    child: Text(
                      'Continue with Phone',
                      style:
                          TextStyle(fontFamily: 'Medium', color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  try {
                    setState(() {
                      googleloading = true;
                    });
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogin(context);
                    print(provider);
                    setState(() {
                      googleloading = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                child: Container(
                  height: 50,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: googleloading!
                        ? CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/google.svg',
                                height: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                    fontFamily: 'Medium', color: Colors.black),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style:
                        TextStyle(fontFamily: 'Regular', color: Colors.white),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailSignUp()),
                          (route) => false);
                    },
                    child: Container(
                      height: 40,
                      child: Center(
                        child: Text(
                          'Sign Up with Email',
                          style: TextStyle(
                              fontFamily: 'Regular', color: Colors.blue),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
