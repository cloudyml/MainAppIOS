import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';

import 'package:page_transition/page_transition.dart';

class PhoneAuthentication extends StatefulWidget {
  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  final _phonekey = GlobalKey<FormState>();
  final _otpkey = GlobalKey<FormState>();
  String? countryCode = '+91';
  late final String? verifyid;
  bool _isloading = false;
  bool _verifyloading = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
      child: ListView(
        padding: EdgeInsets.all(16.0),
        shrinkWrap: true,
        children: [
          Center(
              child: Text(
            "Enter Phone Number",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.055),
          )),
          SizedBox(
            height: height * 0.03,
          ),
          Form(
            key: _phonekey,
            child: Row(
              children: [
                Container(
                  width: width * 0.17,
                  child: TextFormField(
                    initialValue: countryCode,
                    onChanged: (v) {
                      setState(() {
                        countryCode = v;
                      });
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                    decoration: InputDecoration(
                        hintText: 'Code',
                        labelText: 'Code',
                        floatingLabelStyle: TextStyle(
                            fontSize: width * 0.049,
                            fontWeight: FontWeight.w500,
                            color: HexColor('7B62DF')),
                        labelStyle: TextStyle(
                          fontSize: width * 0.049,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor('7B62DF'), width: 2)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: HexColor('7B62DF'), width: 2),
                        ),
                        errorMaxLines: 2),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Code';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: width * 0.07,
                ),
                Flexible(
                  child: TextFormField(
                    controller: mobile,
                    decoration: InputDecoration(
                        hintText: 'Enter Your Number',
                        labelText: 'Phone Number',
                        counterText: '',
                        floatingLabelStyle: TextStyle(
                            fontSize: width * 0.049,
                            fontWeight: FontWeight.w500,
                            color: HexColor('7B62DF')),
                        labelStyle: TextStyle(
                          fontSize: width * 0.049,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor('7B62DF'), width: 2)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: HexColor('7B62DF'), width: 2),
                        ),
                        suffixIcon: Icon(
                          Icons.phone,
                          color: HexColor('6153D3'),
                        )),
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Phone No';
                      } else if (!RegExp(
                              r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                          .hasMatch(value)) {
                        return 'Please enter a valid Phone Number';
                      } else if (value.length < 10) {
                        return 'Enter 10 digit Phone number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.032,
          ),
          Center(
            child: (_isloading)
                ? Loading()
                : InkWell(
                    child: Container(
                      //height: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Send OTP',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: width * 0.054),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: HexColor('6153D3'),
                        borderRadius: BorderRadius.circular(width * 0.015),
                        boxShadow: [
                          BoxShadow(
                            color: HexColor('6153D3'),
                            blurRadius: 10.0, // soften the shadow
                            offset: Offset(
                              0, // Move to right 10  horizontally
                              4.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      if (_phonekey.currentState!.validate()) {
                        setState(() {
                          _isloading = true;
                        });
                        FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.verifyPhoneNumber(
                          phoneNumber: '$countryCode ${mobile.text}',
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {

                              },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                          codeSent: (String verificationId,
                              int? forceResendingToken) {
                            verifyid = verificationId;
                            setState(() {
                              _isloading = false;
                            });
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  Future.delayed(Duration(seconds: 5), () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return AlertDialog(
                                    title: Center(
                                      child: Column(
                                        children: [
                                          Lottie.asset('assets/otplottie.json',
                                              height: height * 0.15,
                                              width: width * 0.5),
                                          Text(
                                            'OTP Sent Successfully',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: width * 0.058,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'OTP has been sent to',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(),
                                        ),
                                        Text(
                                          '${mobile.text}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Please enter the OTP in the field below to verify your phone.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: height * 0.017,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Container(
                                            //height: 20,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: width * 0.049),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: HexColor('6153D3'),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                            showToast('OTP sent');
                          },
                          verificationFailed: (FirebaseAuthException error) {
                            setState(() {
                              _isloading = false;
                            });
                            showToast(
                                'Error Verifying\nPlease check your Mobile Number and try again');
                          },
                        );
                      } else {}
                    },
                  ),
          ),
          SizedBox(
            height: height * 0.034,
          ),
          Divider(
            thickness: 2,
          ),
          SizedBox(
            height: height * 0.034,
          ),
          Center(
              child: Text(
            "Enter OTP",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.055),
          )),
          SizedBox(
            height: height * 0.026,
          ),
          Form(
            key: _otpkey,
            child: TextFormField(
              controller: otp,
              textAlign: TextAlign.center,
              // style: TextStyle(
              //   letterSpacing: 8.0,
              // ),
              //obscureText: true,
              decoration: InputDecoration(
                //hintText: 'Enter One Time Password',
                labelText: 'OTP',
                floatingLabelAlignment: FloatingLabelAlignment.center,
                counterText: '',
                floatingLabelStyle: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.w500,
                    color: HexColor('7B62DF')),
                labelStyle: TextStyle(
                  fontSize: width * 0.049,
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: HexColor('7B62DF'), width: 2)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                ),
                // suffixIcon: Icon(
                //   Icons.lock,
                //   color: HexColor('6153D3'),
                // )
              ),
              keyboardType: TextInputType.phone,
              maxLength: 6,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'OTP is required';
                } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                  return 'OTP must be 6 digits only';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: height * 0.032,
          ),
          Center(
            child: (_verifyloading)
                ? Loading()
                : InkWell(
                    child: Container(
                      //height: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Verify',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: width * 0.054),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: HexColor('6153D3'),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: HexColor('6153D3'),
                            blurRadius: 10.0, // soften the shadow
                            offset: Offset(0, 4.0),
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      if (_otpkey.currentState!.validate()) {
                        setState(() {
                          _verifyloading = true;
                        });
                        FirebaseAuth auth = FirebaseAuth.instance;
                        final code = otp.text.trim();
                        try {
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verifyid!, smsCode: code);
                          var result =
                              await auth.signInWithCredential(credential);

                          setState(() {
                            _verifyloading = false;
                          });

                          AwesomeDialog(
                            context: context,
                            animType: AnimType.LEFTSLIDE,
                            headerAnimationLoop: true,
                            dialogType: DialogType.SUCCES,
                            showCloseIcon: true,
                            title: 'Verified!',
                            desc:
                                'Your Mobile Number\n ${mobile.text} \nhas been successfully verified!\n Please wait you will be redirected to the HomePage.',
                            btnOkOnPress: () {
                              debugPrint('OnClcik');
                            },
                            btnOkIcon: Icons.check_circle,
                            onDissmissCallback: (type) {
                              debugPrint('Dialog Dissmiss from callback $type');
                            },
                          ).show();

                          var user = result.user;
                          if (user != null) {
                            userprofile(name: null,mobilenumber: mobile.text,email: null);
                            await Future.delayed(Duration(seconds: 4));
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
                              _verifyloading = false;
                            });
                            showToast('Incorrect OTP\nPlease try again');
                            print("Error");
                          }
                        } catch (e) {
                          setState(() {
                            _verifyloading = false;
                          });
                          showToast(e.toString());
                        }
                      } else {}
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
