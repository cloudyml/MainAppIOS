import 'dart:async';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:page_transition/page_transition.dart';
import '../globals.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({Key? key}) : super(key: key);

  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
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
        padding: const EdgeInsets.only(left: 20.0, top: 60),
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
                                    child: EmailSignUpPass()),
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

class EmailSignUpPass extends StatefulWidget {
  const EmailSignUpPass({Key? key}) : super(key: key);

  @override
  _EmailSignUpPassState createState() => _EmailSignUpPassState();
}

class _EmailSignUpPassState extends State<EmailSignUpPass> {
  double opacity = 0.0;
  double emailOpacity = 0.0;
  double passOpacity = 0.0;
  String msg = '';
  final loginkey = GlobalKey<FormState>();
  bool loading = false;
  bool confirmEmailLoading = false;
  Timer? timer;

  void checkVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isVerified) {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              duration: Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              type: PageTransitionType.rightToLeft,
              child: DetailsScreen()),
          (route) => false);
      showToast('Email Verified');
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

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
          height: height * 0.6,
          width: width,
          child: Form(
            key: loginkey,
            child: Container(
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/logo2.png',
                    height: 40,
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
                        fontSize: 24,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                  SizedBox(
                    height: height * 0.08,
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
                    height: height * 0.03,
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
                          onPressed: () async {
                            if (emailOpacity == 0.0) {
                              setState(() {
                                opacity = 0.0;
                              });
                            }
                            if (loginkey.currentState!.validate()) {
                              if (emailOpacity == 0) {
                                setState(() {
                                  loading = true;
                                  //confirmEmailLoading = true;
                                });

                                timer = Timer.periodic(Duration(seconds: 3),
                                    (_) => checkVerified());
                                createAccount(email.text, pass.text, pass.text,
                                        context)
                                    .then((user) async {
                                  //await user!.updateDisplayName(name.text);
                                  if (user != null) {
                                    setState(() {
                                      loading = false;
                                      confirmEmailLoading = true;
                                    });
                                    await user.sendEmailVerification();

                                    print(FirebaseAuth
                                        .instance.currentUser!.displayName);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => DetailsScreen()));

                                    //showToast('Account Created');
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    showToast('Account Creation failed');
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
                                  child: loading
                                      ? Container(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Icon(
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  confirmEmailLoading
                      ? Container(
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                width: 260,
                                child: Text(
                                  'Please confirm your email by clicking on the link sent on your email id',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.4),
                                      fontFamily: 'MediumItalic'),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  double opacity = 0.0;
  double emailOpacity = 0.0;
  double passOpacity = 0.0;
  String msg = '';
  final loginkey = GlobalKey<FormState>();
  bool loading = false;
  bool confirmEmailLoading = false;
  Timer? timer;

  void checkVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isVerified) {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              duration: Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              type: PageTransitionType.rightToLeft,
              child: DetailsScreen()),
          (route) => false);
      showToast('Email Verified');
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 48.0, top: 48),
          child: Container(
            height: height * 0.9,
            width: width,
            child: Form(
              key: loginkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/logo2.png',
                    height: 40,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Hello, there',
                    style: TextStyle(fontFamily: 'Bold', fontSize: 40),
                  ),
                  Text(
                    "Enter your Details",
                    style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 24,
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
                  TextFormField(
                    controller: username,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        setState(() {
                          opacity = 1.0;
                          emailOpacity = 1.0;
                          msg = 'Username is required';
                        });
                        return null;
                      } else if (!RegExp(r"^[A-Za-z][A-Za-z0-9_]{7,29}$")
                          .hasMatch(value)) {
                        setState(() {
                          opacity = 1.0;
                          emailOpacity = 1.0;
                          msg = 'Please enter a valid Username';
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
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        fontFamily: "Medium",
                        fontSize: 20, //16,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
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
                  TextFormField(
                    controller: mobile,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        setState(() {
                          opacity = 1.0;
                          emailOpacity = 1.0;
                          msg = 'number is required';
                        });
                        return null;
                      } else if (!RegExp(r"^(\+\d{1,3}[- ]?)?\d{10}$")
                          .hasMatch(value)) {
                        setState(() {
                          opacity = 1.0;
                          emailOpacity = 1.0;
                          msg = 'Please enter a valid Mobile number';
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
                      hintText: 'Mobile number',
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
                    height: 10,
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
                        width: 00,
                      ),
                      MaterialButton(
                          elevation: 0,
                          splashColor: Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          onPressed: () async {
                            if (emailOpacity == 0.0) {
                              setState(() {
                                opacity = 0.0;
                              });
                            }
                            if (loginkey.currentState!.validate()) {
                              if (emailOpacity == 0) {
                                setState(() {
                                  loading = false;

                                  //confirmEmailLoading = true;
                                });
                                userprofile(
                                    username.text, mobile.text, email.text);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => HomePage()));
                                // timer = Timer.periodic(
                                //     Duration(seconds: 3), (_) => checkVerified());
                                // createAccount(email.text, pass.text,)
                                //     .then((user) async {

                                //await user!.updateDisplayName(name.text);
                                // if (user != null) {
                                //   setState(() {
                                //     loading = false;
                                //     confirmEmailLoading = true;
                                //   });
                                //   await user.sendEmailVerification();

                                print(FirebaseAuth
                                    .instance.currentUser!.displayName);

                                //showToast('Account Created');

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
                                  child: loading
                                      ? Container(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Icon(
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
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  confirmEmailLoading
                      ? Container(
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 260,
                                child: Text(
                                  'Please confirm your email by clicking on the \nlink sent on your email id',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.4),
                                      fontFamily: 'MediumItalic'),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
