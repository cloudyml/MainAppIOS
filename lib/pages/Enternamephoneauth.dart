import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/Providers/AppProvider.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../globals.dart';

class EnterNamePhoneAuth extends StatefulWidget {
  const EnterNamePhoneAuth({Key? key}) : super(key: key);

  @override
  State<EnterNamePhoneAuth> createState() => _EnterNamePhoneAuthState();
}

class _EnterNamePhoneAuthState extends State<EnterNamePhoneAuth> {
  GlobalKey<FormState> _formKey = GlobalKey();

  FirebaseFirestore _firestore =FirebaseFirestore.instance;
  final currentUser=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final userprovider=Provider.of<UserProvider>(context);
    final appprovider=Provider.of<AppProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
        backgroundColor: HexColor('7A62DE'),
        body: ListView(
          shrinkWrap: true,
          children: [
            Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: verticalScale*150,
                      ),
                      Container(
                        height: height-verticalScale*150,
                        width: width,
                        decoration:  BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft:  Radius.circular(min(horizontalScale,verticalScale)*25),
                            topRight:  Radius.circular(min(horizontalScale,verticalScale)*25),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 46*verticalScale,
                    left: 28*horizontalScale,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back,color: Colors.white,size: 36,),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                      top: 59*verticalScale,
                      left: 126*horizontalScale,
                      right: 130*horizontalScale,
                      child: Text('Enter Details',
                        textScaleFactor: min(horizontalScale,verticalScale),
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: verticalScale*200,
                      ),
                      Text(
                        'Enter Name',
                        textScaleFactor: min(horizontalScale,verticalScale),
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Bold',
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(horizontalScale*24,verticalScale*22,horizontalScale*24,verticalScale*24),
                          child: TextFormField(
                            controller: username,
                            //inputFormatters: [FilteringTextInputFormatter(RegExp(r'[a-zA-Z]'), allow: true)],
                            decoration: InputDecoration(
                                hintText: 'Enter Your Name',
                                hintStyle: TextStyle(
                                  fontSize: 20 * min(horizontalScale, verticalScale),
                                ),
                                labelText: 'Name',
                                floatingLabelStyle: TextStyle(
                                    fontSize: 18 * min(horizontalScale, verticalScale),
                                    fontWeight: FontWeight.w500,
                                    color: HexColor('7B62DF')),
                                labelStyle: TextStyle(
                                  fontSize: 18 * min(horizontalScale, verticalScale),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: HexColor('7B62DF'), width: 2)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                                ),
                                suffixIcon: Icon(
                                  Icons.person,
                                  color: HexColor('6153D3'),
                                )),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Name';
                              } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                return 'Please enter a valid Name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      appprovider.isLoading?
                      Loading()
                          : ElevatedButton(
                        onPressed: () async{
                          if(_formKey.currentState!.validate()){
                            appprovider.changeIsLoading();
                            _firestore.collection('Users')
                                .doc(userprovider.userModel!.id)
                                .update({
                              'name':username.text,
                            });
                            await Future.delayed(Duration(seconds: 2));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                            currentUser?.updateDisplayName(username.text);
                            appprovider.changeIsLoading();
                          }else{

                          }

                        },
                        child: Padding(
                          padding:  EdgeInsets.all(min(horizontalScale,verticalScale)*11),
                          child: Text(
                            'Save Changes',
                            textScaleFactor: min(horizontalScale,verticalScale),
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Bold',
                                color: Colors.white
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: HexColor('6153D3'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(min(horizontalScale,verticalScale)*10), // <-- Radius
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ],

        )

    );
  }
}
