import 'dart:math';

import 'package:cloudyml_app2/authentication/SignUpForm.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/authentication/loginform.dart';
import 'package:cloudyml_app2/authentication/onboardbg.dart';
import 'package:cloudyml_app2/authentication/phoneauthnew.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class Onboardew extends StatefulWidget {
  const Onboardew({Key? key}) : super(key: key);

  @override
  State<Onboardew> createState() => _OnboardewState();
}

class _OnboardewState extends State<Onboardew> {
  bool? googleloading = false;
  bool formVisible = false;
  bool phoneVisible = false;
  int _formIndex = 1;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    print(height);
    print(width);
    return Scaffold(
        body: Stack(
      children: [
        Onboardbg(),
        Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: verticalScale * 76,
                ),
                Center(
                    child: Image.asset(
                  'assets/logo.png',
                  height: verticalScale * 80,
                  width: horizontalScale * 238,
                )),
                SizedBox(
                  height: verticalScale * 50,
                ),
                RichText(
                    textAlign: TextAlign.center,
                    textScaleFactor: min(horizontalScale, verticalScale),
                    text: TextSpan(
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        children: [
                          TextSpan(text: "Learn "),
                          TextSpan(
                              text: 'data science \n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "and "),
                          TextSpan(
                              text: 'ML ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "on the go with \nour "),
                          TextSpan(
                              text: 'mobile app ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ])),
                SizedBox(
                  height: verticalScale * 47.44,
                ),
                Container(
                  width: horizontalScale * 322,
                  decoration: BoxDecoration(
                      boxShadow: [
                        // color: Colors.white, //background color of box
                        BoxShadow(
                          color: HexColor('977EFF'),
                          blurRadius: 18.0, // soften the shadow
                          offset: Offset(
                            0, // Move to right 10  horizontally
                            10.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(
                        min(horizontalScale, verticalScale) * 25,
                      ))),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        horizontalScale * 24.76,
                        verticalScale * 35.56,
                        horizontalScale * 24.24,
                        verticalScale * 35.56),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              formVisible = true;
                              _formIndex = 1;
                            });
                          },
                          child: Container(
                            height: 45 * verticalScale,
                            width: 273 * horizontalScale,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    min(horizontalScale, verticalScale) * 8),
                                border: Border.all(
                                    color: HexColor('7B62DF'), width: 2)),
                            child: Center(
                              child: Text(
                                'Continue with Email',
                                textScaleFactor:
                                    min(horizontalScale, verticalScale),
                                style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: verticalScale * 21,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              phoneVisible = true;
                            });
                          },
                          child: Container(
                            height: 45 * verticalScale,
                            width: 273 * horizontalScale,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    min(horizontalScale, verticalScale) * 8),
                                border: Border.all(
                                    color: HexColor('7B62DF'), width: 2)),
                            child: Center(
                              child: Text(
                                'Continue with Phone',
                                textScaleFactor:
                                    min(horizontalScale, verticalScale),
                                style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: verticalScale * 21,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            )),
                            SizedBox(
                              width: horizontalScale * 15,
                            ),
                            Text(
                              'OR',
                              textScaleFactor:
                                  min(horizontalScale, verticalScale),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: horizontalScale * 15,
                            ),
                            Expanded(
                                child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: verticalScale * 21,
                        ),
                        InkWell(
                          onTap: () {
                            try {
                              setState(() {
                                googleloading = true;
                              });
                              final provider =
                                  Provider.of<GoogleSignInProvider>(context,
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
                            height: horizontalScale * 45,
                            width: verticalScale * 273,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  min(horizontalScale, verticalScale) * 8),
                              boxShadow: [
                                // color: Colors.white, //background color of box
                                BoxShadow(
                                  color: HexColor('977EFF'),
                                  blurRadius: 10.0, // soften the shadow
                                  offset: Offset(
                                    0, // Move to right 10  horizontally
                                    2.0, // Move to bottom 10 Vertically
                                  ),
                                )
                              ],
                            ),
                            child: Center(
                              child: googleloading!
                                  ? CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/google.svg',
                                          height: min(horizontalScale,
                                                  verticalScale) *
                                              26,
                                          width: min(horizontalScale,
                                                  verticalScale) *
                                              26,
                                        ),
                                        Text(
                                          'Continue with Google',
                                          textScaleFactor: min(
                                              horizontalScale, verticalScale),
                                          style: TextStyle(
                                              fontFamily: 'SemiBold',
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: verticalScale * 44,
                        ),
                        Text(
                          'Don’t have an account?',
                          textScaleFactor: min(horizontalScale, verticalScale),
                          style: TextStyle(fontSize: 20),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              formVisible = true;
                              _formIndex = 2;
                            });
                          },
                          child: Center(
                            child: Text(
                              'Sign Up with Email',
                              textScaleFactor:
                                  min(horizontalScale, verticalScale),
                              style: TextStyle(
                                  fontFamily: 'SemiBold',
                                  color: HexColor('0047FF'),
                                  fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: verticalScale * 73.56,
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Need Help?',
                    textScaleFactor: min(horizontalScale, verticalScale),
                    style: TextStyle(
                        fontFamily: 'Regular',
                        fontSize: 18,
                        color: HexColor('9C9C9C')),
                  ),
                ),
                // SizedBox(
                //   height: height*0.0705,
                // ),
              ],
            ),
          ),
        ),
        AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: (formVisible)
                ? (_formIndex == 1)
                    ? Container(
                        color: Colors.black54,
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.06)),
                                      ),
                                      child: Text(
                                        'Login',
                                        textScaleFactor:
                                            min(horizontalScale, verticalScale),
                                        style: TextStyle(
                                          color: HexColor('6153D3'),
                                          fontSize: 18,
                                        ),
                                      )),
                                  SizedBox(
                                    width: horizontalScale * 17,
                                  ),
                                  IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          formVisible = false;
                                        });
                                      },
                                      icon: Icon(Icons.clear))
                                ],
                              ),
                              Container(
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 200),
                                  child: LoginForm(),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.black54,
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.06)),
                                      ),
                                      child: Text('SignUp',
                                          textScaleFactor: min(
                                              horizontalScale, verticalScale),
                                          style: TextStyle(
                                            color: HexColor('6153D3'),
                                            fontSize: 18,
                                          ))),
                                  SizedBox(
                                    width: horizontalScale * 17,
                                  ),
                                  IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          formVisible = false;
                                        });
                                      },
                                      icon: Icon(Icons.clear))
                                ],
                              ),
                              Container(
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 200),
                                  child: SignUpform(),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                : null),
        AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: (phoneVisible)
                ? Container(
                    color: Colors.black54,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            width * 0.06)),
                                  ),
                                  child: Text('OTP Verification',
                                      textScaleFactor:
                                          min(horizontalScale, verticalScale),
                                      style: TextStyle(
                                        color: HexColor('6153D3'),
                                        fontSize: 18,
                                      ))),
                              SizedBox(
                                width: horizontalScale * 17,
                              ),
                              IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      phoneVisible = false;
                                    });
                                  },
                                  icon: Icon(Icons.clear))
                            ],
                          ),
                          Container(
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: PhoneAuthentication(),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : null)
      ],
    ));
  }
}