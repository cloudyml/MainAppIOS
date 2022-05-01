import 'package:cloudyml_app2/authentication/email_signup.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:page_transition/page_transition.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  double opacity = 0.0;
  double emailOpacity = 0.0;
  double passOpacity = 0.0;
  String msg = '';
  final GlobalKey<FormState> loginkey = GlobalKey<FormState>();
  bool loading = false;
  bool sentloading = false;
  String? countryCode = '+91';

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
                  height: 75,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Hello',
                  style: TextStyle(fontFamily: 'Bold', fontSize: 40),
                ),
                Text(
                  "Please enter your Mobile Number",
                  style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 24,
                      color: Colors.black.withOpacity(0.4)),
                ),
                SizedBox(
                  height: 80,
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      child: TextFormField(
                        initialValue: countryCode,
                        onChanged: (v) {
                          setState(() {
                            countryCode = v;
                          });
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(' ')
                        ],
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
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          filled: false,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: mobile,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            setState(() {
                              opacity = 1.0;
                              emailOpacity = 1.0;
                              msg = 'Mobile Number is required';
                            });
                            return null;
                          } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10}$)')
                              .hasMatch(value)) {
                            setState(() {
                              opacity = 1.0;
                              emailOpacity = 1.0;
                              msg = 'Please enter a valid Mobile Number';
                            });
                            return null;
                          }
                          setState(() {
                            emailOpacity = 0.0;
                          });
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(' ')
                        ],
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
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          filled: false,
                          fillColor: Colors.white.withOpacity(0.1),
                          suffixIcon: Icon(
                            Icons.error,
                            size: 15,
                            color: Colors.red.withOpacity(emailOpacity),
                          ),
                          hintText: 'Mobile Number',
                          hintStyle: TextStyle(
                            fontFamily: "Medium",
                            fontSize: 20, //16,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                        onPressed: () async {
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
                              FirebaseAuth auth = FirebaseAuth.instance;
                              setState(() {
                                sentloading = true;
                              });

                              await auth.verifyPhoneNumber(
                                phoneNumber: '$countryCode ${mobile.text}',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) async {
                                  /*var result = await auth
                                      .signInWithCredential(credential);
                                  showToast('Account Created');
                                  var user = result.user;

                                  if (user != null) {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.bounceInOut,
                                          type: PageTransitionType.rightToLeft,
                                          child: HomePage()),
                                    );
                                  } else {
                                    showToast(
                                        'Error creating account\nPlease try again');
                                  }*/
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                                codeSent: (String verificationId,
                                    int? forceResendingToken) {
                                  showToast('OTP sent');
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        duration: Duration(milliseconds: 400),
                                        curve: Curves.bounceInOut,
                                        type: PageTransitionType.rightToLeft,
                                        child: PhoneOTP(
                                          verificationId: verificationId,
                                        )),
                                  );
                                },
                                verificationFailed:
                                    (FirebaseAuthException error) {
                                  //Navigator.pop(context);
                                  setState(() {
                                    sentloading = false;
                                  });
                                  showToast(
                                      'Error Verifying\nPlease check your Mobile Number and try again');
                                },
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
                                child: sentloading
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
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class PhoneOTP extends StatefulWidget {
  final String? verificationId;
  const PhoneOTP({this.verificationId});

  @override
  _PhoneOTPState createState() => _PhoneOTPState();
}

class _PhoneOTPState extends State<PhoneOTP> {
  double opacity = 0.0;
  double emailOpacity = 0.0;
  double passOpacity = 0.0;
  String msg = '';
  final GlobalKey<FormState> loginkey = GlobalKey<FormState>();
  bool loading = false;
  bool sentloading = false;
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
                  height: 75,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Verification',
                  style: TextStyle(fontFamily: 'Bold', fontSize: 40),
                ),
                Text(
                  "Please enter your OTP for verification",
                  style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 24,
                      color: Colors.black.withOpacity(0.4)),
                ),
                SizedBox(
                  height: 80,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: otp,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      setState(() {
                        opacity = 1.0;
                        emailOpacity = 1.0;
                        msg = 'OTP is required';
                      });
                      return null;
                    } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                      setState(() {
                        opacity = 1.0;
                        emailOpacity = 1.0;
                        msg = 'OTP must be 6 digits only';
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
                    hintText: 'One Time Password',
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
                        onPressed: () async {
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
                              setState(() {
                                sentloading = true;
                              });
                              FirebaseAuth _auth = FirebaseAuth.instance;
                              final code = otp.text.trim();
                              try {
                                AuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: widget.verificationId!,
                                        smsCode: code);

                                var result = await _auth
                                    .signInWithCredential(credential);

                                var user = result.user;
                                if (user != null) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        duration: Duration(milliseconds: 400),
                                        curve: Curves.bounceInOut,
                                        type: PageTransitionType.rightToLeft,
                                        child: DetailsScreen()),
                                  );
                                } else {
                                  setState(() {
                                    sentloading = false;
                                  });
                                  showToast('Incorrect OTP\nPlease try again');
                                  print("Error");
                                }
                              } catch (e) {
                                setState(() {
                                  sentloading = false;
                                });
                                showToast('Incorrect OTP\nPlease try again');
                              }
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
                                child: sentloading
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
