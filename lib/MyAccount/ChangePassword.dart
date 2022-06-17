import 'dart:math';

import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final newpasswordController=TextEditingController();
  final currentuser=FirebaseAuth.instance.currentUser;
  bool _isHidden = true;
  void _togglepasswordview() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  changePassword() async{
        try{
          await currentuser!.updatePassword(newpasswordController.text);
          logOut(context);
        }catch(error){

        }
  }
  @override
  Widget build(BuildContext context) {
    final userprovider=Provider.of<UserProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Container(
            child:Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(min(horizontalScale,verticalScale)*20.0),
                  child: Text('Change Password',
                    textAlign:TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        color:HexColor('7A62DE'),
                        fontWeight: FontWeight.bold
                    ),
                    textScaleFactor:min(horizontalScale,verticalScale) ,
                  ),
                ),
                Text('Use the form below to change the password for your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                  ),
                  textScaleFactor:min(horizontalScale,verticalScale) ,
                ),
                SizedBox(
                  height: verticalScale*20,
                ),
                Divider(thickness: 2,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Email Id: ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),
                    textScaleFactor:min(horizontalScale,verticalScale) ,
                  ),
                ),
                SizedBox(height: verticalScale*10,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(userprovider.userModel!.email??'',
                    style: TextStyle(
                        fontSize: 16,
                        //fontWeight: FontWeight.w600
                    ),
                    textScaleFactor:min(horizontalScale,verticalScale) ,
                  ),
                ),
                SizedBox(height: verticalScale*10,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Name: ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),
                    textScaleFactor:min(horizontalScale,verticalScale) ,
                  ),
                ),
                SizedBox(height: verticalScale*10,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(userprovider.userModel!.name??'',
                    style: TextStyle(
                      fontSize: 16,
                      //fontWeight: FontWeight.w600
                    ),
                    textScaleFactor:min(horizontalScale,verticalScale) ,
                  ),
                ),
                Divider(thickness: 2,),
                SizedBox(height: verticalScale*10,),
                Text('Enter New Password ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
                  textScaleFactor:min(horizontalScale,verticalScale) ,
                ),
                SizedBox(height: verticalScale*18,),
                TextFormField(
                  controller: pass,
                  decoration: InputDecoration(
                      hintText: 'Enter new Password',
                      hintStyle: TextStyle(
                        fontSize: 20 * min(horizontalScale, verticalScale),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 18 * min(horizontalScale, verticalScale),
                      ),
                      labelText: 'Password',
                      floatingLabelStyle: TextStyle(
                          fontSize: 18 * min(horizontalScale, verticalScale),
                          fontWeight: FontWeight.w500,
                          color: HexColor('7B62DF')),
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
                      return 'Set the Password';
                    } else if (!RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                        .hasMatch(value)) {
                      return 'Password must have atleast one Uppercase, one Lowercase, one special character, and one numeric value';
                    }
                    return null;
                  },
                ),
              ],
            )
        ),
      ),
    );
  }
}