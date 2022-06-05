import 'dart:math';

import 'package:cloudyml_app2/globals.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
      //backgroundColor: HexColor('7A62DE'),
      body: ListView( 
        padding: EdgeInsets.all(0),
        children:[
          Stack(
            children: [
              Container(
                height: 207*verticalScale,
                width: width,
                decoration:  BoxDecoration(
                  color: HexColor('7A62DE'),
                  borderRadius: BorderRadius.only(
                    bottomLeft:  Radius.circular(min(horizontalScale,verticalScale)*25),
                    bottomRight:  Radius.circular(min(horizontalScale,verticalScale)*25),
                  ),
                ),
              ),
              Positioned(
                top: 41*verticalScale,
                left: 26*horizontalScale,
                child: IconButton(
                  icon: Icon(Icons.arrow_back,color: Colors.white,size: 36*min(horizontalScale,verticalScale),),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: verticalScale*41,
                    ),
                    Text(
                      'Edit Profile',
                      textScaleFactor: min(horizontalScale,verticalScale),
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'SemiBold',
                          color: Colors.white
                      ),
                    ),
                    SizedBox(height: verticalScale*51,),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        child: Container(
                          height: verticalScale*158,
                          width: horizontalScale*158,
                          child: CircleAvatar(
                            radius: min(horizontalScale,verticalScale)*32.0,
                            backgroundColor: HexColor('6153D3'),
                            child: Container(
                              height: verticalScale*154,
                              width: horizontalScale*154,
                              child: CircleAvatar(
                                  radius: min(horizontalScale,verticalScale)*30.0,
                                  backgroundImage:AssetImage('assets/user.jpg'),
                                  backgroundColor: Colors.transparent,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: CircleAvatar(
                                      radius: min(horizontalScale,verticalScale)*26,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.edit,
                                        size: min(horizontalScale,verticalScale)*30,
                                        color: HexColor('6153D3'),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: verticalScale*40,),
                    Text(
                      'Edit Details',
                      textScaleFactor: min(horizontalScale,verticalScale),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Bold',
                      ),
                    ),
                    TextFormField(
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
                    SizedBox(
                      height: verticalScale * 12,
                    ),
                    TextFormField(
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
                    SizedBox(
                      height: verticalScale * 12,
                    ),
                    TextFormField(
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
                    SizedBox(
                      height: verticalScale * 12,
                    ),
                    TextFormField(
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
                    SizedBox(
                      height: verticalScale * 12,
                    ),
                    TextFormField(
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
                    SizedBox(
                      height: verticalScale * 12,
                    ),TextFormField(
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
                    SizedBox(
                      height: verticalScale * 12,
                    ),

                  ],
                ),
              )
            ],
          ),
        ]

      ),
    );
  }
}
