import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:page_transition/page_transition.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double opacity = 0.0;
  double emailOpacity = 0.0;
  double passOpacity = 0.0;
  String msg = '';
  final GlobalKey<FormState> loginkey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 48.0, top: 48),
        child: Container(
          height: height,
          width: width,
          child: Form(
            key: loginkey,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo2.png',
                  height: 70,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Hello',
                  style: TextStyle(fontFamily: 'Bold', fontSize: 40),
                ),
                Text(
                  "Let's introduce",
                  style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 30,
                      color: Colors.black.withOpacity(0.4)),
                ),
                SizedBox(
                  height: 80,
                ),
                TextFormField(
                  controller: email,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      setState(() {
                        opacity = 1.0;
                        emailOpacity = 1.0;
                        msg = 'Email is required';
                      });
                      return null;
                    } else if (!RegExp(
                            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                        .hasMatch(value)) {
                      setState(() {
                        opacity = 1.0;
                        emailOpacity = 1.0;
                        msg = 'Please enter a valid Email Address';
                      });
                      return null;
                    }
                    setState(() {
                      emailOpacity = 0.0;
                    });
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                  style: TextStyle(
                    fontFamily: "Medium",
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.3), width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    filled: false,
                    fillColor: Colors.white.withOpacity(0.1),
                    suffixIcon: Icon(
                      Icons.error,
                      size: 15,
                      color: Colors.red.withOpacity(emailOpacity),
                    ),
                    hintText: 'Email Address',
                    hintStyle: TextStyle(
                      fontFamily: "Medium",
                      fontSize: 20, //16,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 300),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 10,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Container(
                        width: width * 0.8,
                        child: Text(
                          msg,
                          style: TextStyle(
                              color: Colors.red, fontFamily: 'MediumItalic'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 30,
                        child: Icon(
                          Iconsax.arrow_left,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    MaterialButton(
                        elevation: 0,
                        splashColor: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          if (emailOpacity == 0.0) {
                            setState(() {
                              opacity = 0.0;
                            });
                          }
                          if (loginkey.currentState!.validate()) {
                            /*setState(() {
                              loading = true;
                            });*/
                            if (emailOpacity == 0.0) {
                              Navigator.push(
                                context,
                                PageTransition(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.bounceInOut,
                                    type: PageTransitionType.rightToLeft,
                                    child: OTPmail()),
                              );
                            }
                          } else {}
                        },
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        child: Container(
                          height: 60,
                          width: 140,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: gradient),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Iconsax.arrow_right_1,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        )),
                    /*Container(
                      height: 60,
                      width: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: gradient),
                      child: Center(
                        child: Icon(
                          Iconsax.arrow_right_1,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),*/
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class OTPmail extends StatefulWidget {
  const OTPmail({Key? key}) : super(key: key);

  @override
  _OTPmailState createState() => _OTPmailState();
}

class _OTPmailState extends State<OTPmail> {
  double opacity = 0.0;
  double emailOpacity = 0.0;
  double passOpacity = 0.0;
  String msg = '';
  final loginkey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 60),
        child: Container(
          height: height ,
          width: width,
          child: Form(
            key: loginkey,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo2.png',
                  height: 70,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Verification',
                  style: TextStyle(fontFamily: 'Bold', fontSize: 40),
                ),
                Text(
                  "Enter the password for ${email.text}",
                  style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.4)),
                ),
                SizedBox(
                  height: 60,
                ),
                TextFormField(
                  controller: pass,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      setState(() {
                        opacity = 1.0;
                        emailOpacity = 1.0;
                        msg = 'Password is required';
                      });
                      return null;
                    } else if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                        .hasMatch(value)) {
                      setState(() {
                        opacity = 1.0;
                        emailOpacity = 1.0;
                        msg =
                            'Password must have atleast one Uppercase, one Lowercase, one special character, and one numeric value';
                      });
                      return null;
                    }
                    setState(() {
                      emailOpacity = 0.0;
                    });
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                  style: TextStyle(
                    fontFamily: "Medium",
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 3),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    suffixIcon: Icon(
                      Icons.error,
                      size: 15,
                      color: Colors.red.withOpacity(emailOpacity),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      fontFamily: "Medium",
                      fontSize: 20, //16,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 300),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 10,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Container(
                        width: width * 0.8,
                        child: Text(
                          msg,
                          style: TextStyle(
                              color: Colors.red, fontFamily: 'MediumItalic'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: Container(
                        height: 50,
                        width: 30,
                        child: Icon(
                          Iconsax.arrow_left,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    MaterialButton(
                        elevation: 0,
                        splashColor: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          if (emailOpacity == 0.0) {
                            setState(() {
                              opacity = 0.0;
                            });
                          }
                          if (loginkey.currentState!.validate()) {
                            if (emailOpacity == 0) {
                              logIn(email.text, pass.text).then((user) async {
                                if (user != null) {
                                  setState(() {
                                    opacity = 0.0;
                                    loading = false;
                                  });
                                  print(user);

                                  showToast('Logged in successfully');
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      PageTransition(
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.bounceInOut,
                                          type: PageTransitionType.rightToLeft,
                                          child: HomePage()),
                                      (route) => false);
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  showToast('Login failed');
                                }
                              });
                            }
                          }
                        },
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        child: Container(
                          height: 60,
                          width: 140,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: gradient),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Iconsax.arrow_right_1,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        )),
                    /*Container(
                      height: 60,
                      width: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: gradient),
                      child: Center(
                        child: Icon(
                          Iconsax.arrow_right_1,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),*/
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
