import 'dart:math';

import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isHidden = true;
  bool _isLoading = false;
  final _loginkey = GlobalKey<FormState>();

  void _togglepasswordview() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Form(
      key: _loginkey,
      child: Container(
        margin: EdgeInsets.all( min(horizontalScale, verticalScale)*24),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular( min(horizontalScale, verticalScale)*25)),
        child: ListView(
          padding: EdgeInsets.fromLTRB(horizontalScale*25,  verticalScale*36, horizontalScale*24, verticalScale*36),
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                  hintText: 'Enter Your Email',
                  labelText: 'Email',
                  floatingLabelStyle: TextStyle(
                      fontSize: 18*min(horizontalScale, verticalScale),
                      fontWeight: FontWeight.w500,
                      color: HexColor('7B62DF')),
                  labelStyle: TextStyle(
                    fontSize: 18*min(horizontalScale, verticalScale),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor('7B62DF'), width: 2)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                  ),
                  suffixIcon: Icon(
                    Icons.email,
                    color: HexColor('6153D3'),
                  )),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter email address';
                } else if (!RegExp(
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?"
                        r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(
              height: verticalScale*16,
            ),
            TextFormField(
              controller: pass,
              decoration: InputDecoration(
                  hintText: 'Enter Password',
                  labelText: 'Password',
                  floatingLabelStyle: TextStyle(
                      fontSize: 18*min(horizontalScale, verticalScale),
                      fontWeight: FontWeight.w500,
                      color: HexColor('7B62DF')),
                  labelStyle: TextStyle(fontSize: 18*min(horizontalScale, verticalScale)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor('7B62DF'), width: 2)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                  ),
                  suffix: InkWell(
                    onTap: _togglepasswordview,
                    child: Icon(
                      _isHidden ? Icons.visibility_off : Icons.visibility,
                      color: HexColor('6153D3'),
                    ),
                  ),
                  errorMaxLines: 2),
              obscureText: _isHidden,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter the Password';
                } else if (!RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                    .hasMatch(value)) {
                  return 'Password must have atleast one Uppercase, one Lowercase, one special character, and one numeric value';
                }
                return null;
              },
            ),
            SizedBox(
              height: verticalScale*9,
            ),
            Text(
              'Forgot Password?',
              textScaleFactor: min(horizontalScale, verticalScale),
              textAlign: TextAlign.end,
              style:
                  TextStyle(color: HexColor('0047FF'), fontSize: 16),
            ),
            SizedBox(
              height: verticalScale*12,
            ),
            Center(
              child: (_isLoading)
                  ? Loading()
                  : ElevatedButton(
                      child: Text(
                        'Login',
                        textScaleFactor: min(horizontalScale, verticalScale),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: HexColor('6153D3'),
                      ),
                      onPressed: () {
                        if (_loginkey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          logIn(email.text, pass.text).then((user) async {
                            if (user != null) {
                              print(user);
                              showToast('Logged in Successfully');
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.bounceInOut,
                                      type: PageTransitionType.rightToLeft,
                                      child: HomePage()),
                                  (route) => false);
                              setState(() {
                                _isLoading = false;
                              });
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Center(
                                            child: Text(
                                              'Error',
                                              textScaleFactor: min(horizontalScale, verticalScale),
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          content: Text(
                                              '       There is no user record \n corresponding to the identifier.',
                                            textScaleFactor: min(horizontalScale, verticalScale),
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          actions: [
                                            TextButton(
                                                child: Text('Retry'),
                                                onPressed: () {
                                                  // setState(() {
                                                  //   isLoading=false;
                                                  //   // dispose();
                                                  // });
                                                  Navigator.pop(context, true);
                                                })
                                          ]);
                                    });
                              }
                              showToast('Login failed');
                            }
                          });
                        }
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
