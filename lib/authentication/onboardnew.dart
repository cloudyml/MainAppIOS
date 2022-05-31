import 'package:cloudyml_app2/authentication/SignUpForm.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/authentication/loginform.dart';
import 'package:cloudyml_app2/authentication/onboardbg.dart';
import 'package:cloudyml_app2/authentication/phoneauthnew.dart';
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
                  height: height * 0.1,
                ),
                Center(
                    child: Image.asset(
                  'assets/logo.png',
                  height: height * 0.085,
                )),
                SizedBox(
                  height: height * 0.07,
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(
                          fontSize: width * 0.064,
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
                  height: height * 0.05,
                ),
                Container(
                  //height: 20,
                  width: width * 0.8,
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
                      borderRadius:
                          BorderRadius.all(Radius.circular(width * 0.074))),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(width * 0.045, height * 0.035,
                        width * 0.045, height * 0.035),
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
                            height: height * 0.0588,
                            width: width,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(width * 0.03),
                                border: Border.all(
                                    color: HexColor('7B62DF'), width: 2)),
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  'Continue with Email',
                                  style: TextStyle(
                                      fontFamily: 'SemiBold',
                                      color: Colors.black,
                                      fontSize: width * 0.047),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.018,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              phoneVisible = true;
                            });
                          },
                          child: Container(
                            height: height * 0.0588,
                            width: width,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(width * 0.03),
                                border: Border.all(
                                    color: HexColor('7B62DF'), width: 2)),
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  'Continue with Phone',
                                  style: TextStyle(
                                      fontFamily: 'SemiBold',
                                      color: Colors.black,
                                      fontSize: width * 0.047),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.016,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.03,
                            ),
                            Expanded(
                                child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            )),
                            SizedBox(
                              width: width * 0.03,
                            ),
                            Text(
                              'OR',
                              style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: width * 0.03,
                            ),
                            Expanded(
                                child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            )),
                            SizedBox(
                              width: width * 0.03,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.016,
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
                            height: height * 0.0588,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(width * 0.03),
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
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/google.svg',
                                          height: height * 0.025,
                                        ),
                                        SizedBox(
                                          width: width * 0.03,
                                        ),
                                        FittedBox(
                                          child: Text(
                                            'Continue with Google',
                                            style: TextStyle(
                                                fontFamily: 'SemiBold',
                                                color: Colors.black,
                                                fontSize: width * 0.047),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.030,
                        ),
                        Text(
                          'Don’t have an account?',
                          style: TextStyle(fontSize: width * 0.047),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              formVisible = true;
                              _formIndex = 2;
                            });
                          },
                          child: Container(
                            height: height * 0.047,
                            child: Center(
                              child: Text(
                                'Sign Up with Email',
                                style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    color: HexColor('0047FF'),
                                    fontSize: width * 0.047),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.0705,
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Need Help?',
                    style: TextStyle(
                        fontFamily: 'Regular',
                        fontSize: width * 0.045,
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
                                        style: TextStyle(
                                          color: HexColor('6153D3'),
                                          fontSize: width * 0.049,
                                        ),
                                      )),
                                  SizedBox(
                                    width: width * 0.024,
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
                                          style: TextStyle(
                                            color: HexColor('6153D3'),
                                            fontSize: width * 0.049,
                                          ))),
                                  SizedBox(
                                    width: width * 0.024,
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
                                      style: TextStyle(
                                        color: HexColor('6153D3'),
                                        fontSize: width * 0.049,
                                      ))),
                              SizedBox(
                                width: width * 0.017,
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
