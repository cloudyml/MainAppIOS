// ignore: import_of_legacy_library_into_null_safe
import 'dart:math';

import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/api/firebase_api.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloudyml_app2/store.dart';
import 'package:flutter/material.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:cloudyml_app2/models/firebase_file.dart';
// import 'package:ribbon/ribbon.dart';
import 'package:ribbon_widget/ribbon_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/aboutus.dart';
import 'package:cloudyml_app2/payments_history.dart';
import 'package:cloudyml_app2/my_Courses.dart';
import 'package:cloudyml_app2/privacy_policy.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<FirebaseFile>> futureFiles;
  List<Icon> list = [];

  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
    futureFiles = FirebaseApi.listAll('reviews/');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: width,
            height: height * 2.82,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
                // bottomLeft: Radius.circular(50),
                // bottomRight: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.3499999940395355),
                    offset: Offset(5, 5),
                    blurRadius: 52)
              ],
              color: Color.fromRGBO(249, 249, 249, 1),
            ),
            child: Stack(
              children: [
                Positioned(
                    top: -1.9999924898147583,
                    // left: 0,
                    // right: 0,
                    child: SingleChildScrollView(
                      child: Container(
                          width: 360.9999694824219,
                          height: 240.9999694824219,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            image: DecorationImage(
                              alignment: Alignment.center,
                              image: AssetImage('assets/ggf23.png'),
                              fit: BoxFit.fill
                            ),
                          )),
                    )),
                Positioned(
                    top: 274.0000305175781,
                    left: 23.000001907348633,
                    child: Text(
                      'Feature Courses',
                      textScaleFactor: min(horizontalScale, verticalScale),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    )),
                Positioned(
                  top: 312.0000610351562,
                  left: 10.000001907348633,
                  child: Ribbon(
                    nearLength: 1,
                    farLength: .5,
                    title: '',
                    titleStyle: TextStyle(
                        color: Colors.black,
                        // Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    color: Color.fromARGB(255, 11, 139, 244),
                    location: RibbonLocation.topStart,
                    child: Container(
                      width: width * .94,
                      height: height * .18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 8.0,
                              spreadRadius: .09,
                              offset: Offset(1, 5),
                            )
                          ]),
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('courses')
                            .where('FC', isEqualTo: '1')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          DocumentSnapshot document = snapshot.data!.docs[0];
                          Map<String, dynamic> map = snapshot.data!.docs[0]
                              .data() as Map<String, dynamic>;
                          if (!snapshot.hasData) return const SizedBox.shrink();
                          return InkWell(
                            onTap: () {
                              setState(() {
                                courseId = document.id;
                                print(document.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CatelogueScreen()),
                                );
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: width * .4,
                                    height: height * .15,
                                    margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      color: Colors.white,
                                    ),
                                    child: img(width, height, map['image_url'])),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      colname(
                                          map['name'], ''),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Star(),
                                      SizedBox(height: 10),
                                      Button1(width, map['Course Price']),
                                    ])
                              ],
                            ),
                            // print(courseId);
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 456.0000610351562,
                  left: 10.000001907348633,
                  child: Ribbon(
                    nearLength: 68,
                    farLength: 38,
                    title: 'Sale',
                    titleStyle: TextStyle(
                        color: Colors.black,
                        // Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    color: Color.fromARGB(255, 11, 139, 244),
                    location: RibbonLocation.topStart,
                    child: Container(
                      width: width * .94,
                      height: height * .18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 8.0,
                              spreadRadius: .09,
                              offset: Offset(1, 5),
                            )
                          ]),
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('courses')
                            .where('FC', isEqualTo: '2')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          DocumentSnapshot document = snapshot.data!.docs[0];
                          Map<String, dynamic> map = snapshot.data!.docs[0]
                              .data() as Map<String, dynamic>;
                          if (!snapshot.hasData) return const SizedBox.shrink();
                          return InkWell(
                            onTap: () {
                              setState(() {
                                courseId = document.id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CatelogueScreen()),
                                );
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: width * .5,
                                    height: height * .2,
                                    margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      color: Colors.white,
                                    ),
                                    child: img(width, height, map['image_url'])),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      colname(map['name'], ''),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Star(),
                                      SizedBox(height: 10),
                                      Buttoncombo(width, '10,999', '3,999'),
                                    ])
                              ],
                            ),
                            // print(courseId);
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 602.0000610351562,
                  left: 10.000001907348633,
                  child: Ribbon(
                    nearLength: 1,
                    farLength: .5,
                    title: '',
                    titleStyle: TextStyle(
                        color: Colors.black,
                        // Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    color: Color.fromARGB(255, 11, 139, 244),
                    location: RibbonLocation.topStart,
                    child: Container(
                      width: width * .94,
                      height: height * .18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 8.0,
                              spreadRadius: .09,
                              offset: Offset(1, 5),
                            )
                          ]),
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('courses')
                            .where('FC', isEqualTo: '3')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          DocumentSnapshot document = snapshot.data!.docs[0];
                          Map<String, dynamic> map = snapshot.data!.docs[0]
                              .data() as Map<String, dynamic>;
                          if (!snapshot.hasData) return const SizedBox.shrink();
                          return InkWell(
                            onTap: () {
                              setState(() {
                                courseId = document.id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CatelogueScreen()),
                                );
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: width * .4,
                                    height: height * .15,
                                    margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black,
                                    ),
                                    child: img(width, height, map['image_url'])),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      colname(
                                          map['name'], ''),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Star(),
                                      SizedBox(height: 10),
                                      Button1(width, map['Course Price'])
                                    ])
                              ],
                            ),
                            // print(courseId);
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 765.0000305175781,
                    left: 23.000001907348633,
                    child: Text(
                      'Success Stories',
                      textScaleFactor: min(horizontalScale, verticalScale),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    )),
                Positioned(
                  top: 787.0000305175781,
                  left: 5.000001907348633,
                  child: Container(
                    height: height * .9,
                    width: width,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: FutureBuilder<List<FirebaseFile>>(
                      future: futureFiles,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                'Some error occurred!',
                                textScaleFactor:
                                    min(horizontalScale, verticalScale),
                              ));
                            } else {
                              final files = snapshot.data!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // buildHeader(files.length),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: files.length,
                                      itemBuilder: (context, index) {
                                        final file = files[index];

                                        return buildFile(context, file);
                                      },
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 1,
                                              mainAxisSpacing: 4),
                                    ),
                                  ),
                                ],
                              );
                            }
                        }
                      },
                    ),
                  ),
                ),
                Positioned(
                    top: 1365.0000305175781,
                    left: 5.000001907348633,
                    child: safearea1(context)),
                Positioned(
                  top: 2085.0000305175781,
                  left: 15.000001907348633,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromARGB(255, 6, 240, 185),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 8.0,
                            spreadRadius: .09,
                            offset: Offset(1, 5),
                          )
                        ]),
                    width: width * .79,
                    height: height * .045,
                    child: Row(
                      children: [
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  StoreScreen()),
                            );
                          },
                          child: Text(
                            'My Recomemded Courses',
                            textScaleFactor:
                                min(horizontalScale, verticalScale),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: .01,
                        ),
                        Icon(
                          Icons.arrow_circle_right,
                          size: 30,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 15.0000305175781,
                    left: 5.000001907348633,
                    child: Container(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: Icon(
                              Icons.menu,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Text(
                            'Home',
                            textScaleFactor:
                                min(horizontalScale, verticalScale),
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
