import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/combo/combo_course.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/course.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

import 'catalogue_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchString = "";
  // bool? whetherSubScribedToPayInParts = false;
  String id = "";

  // String daysLeftOfLimitedAccess = "";
  List<dynamic> courses = [];

  Map userMap = Map<String, dynamic>();

  bool? load = true;

  void fetchCourses() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        courses = value.data()!['paidCourseNames'];
        load = false;
      });
    });
  }

  // void dbCheckerForDaysLeftForLimitedAccess() async {
  //   DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   Map map = snapshot.data() as Map<String, dynamic>;
  //   Duration daysLeft =
  //       (map['endDateOfLimitedAccess'].difference(DateTime.now()).inDays());
  //   setState(() {
  //     daysLeftOfLimitedAccess = daysLeft.toString();
  //   });
  // }

  void dbCheckerForPayInParts() async {
    DocumentSnapshot userDocs = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    // print(map['payInPartsDetails'][id]['outStandingAmtPaid']);
    setState(() {
      userMap = userDocs.data() as Map<String, dynamic>;
      // whetherSubScribedToPayInParts =
      //     !(!(map['payInPartsDetails']['outStandingAmtPaid'] == null));
    });
  }

  bool navigateToCatalogueScreen(String id) {
    if (userMap['payInPartsDetails'][id] != null) {
      final daysLeft = (DateTime.parse(
              userMap['payInPartsDetails'][id]['endDateOfLimitedAccess'])
          .difference(DateTime.now())
          .inDays);
      print(daysLeft);
      return daysLeft < 0;
      // final secondsLeft = (DateTime.parse(
      //         userMap['payInPartsDetails'][id]['endDateOfLimitedAccess'])
      //     .difference(DateTime.now())
      //     .inSeconds);
      // print(secondsLeft);
      // return secondsLeft < 0;
    } else {
      return false;
    }
    // final secondsLeft = (DateTime.parse(
    //         userMap['payInPartsDetails'][id]['endDateOfLimitedAccess'])
    //     .difference(DateTime.now())
    //     .inSeconds);
    // print(secondsLeft);
    // return secondsLeft < 0;
  }

  bool statusOfPayInParts(String id) {
    if (!(userMap['payInPartsDetails'][id] == null)) {
      if (userMap['payInPartsDetails'][id]['outStandingAmtPaid']) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCourses();
    dbCheckerForPayInParts();
    // dbCheckerForDaysLeftForLimitedAccess();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
        // appBar: AppBar(title:Text('My Courses'),elevation: 0,centerTitle: true,),
        //   backgroundColor: Colors.white,
        body: Stack(
      children: [
        Positioned(
          top: -147.00001525878906 * verticalScale,
          left: 2.384185791015625e-7 * horizontalScale,
          child: Container(
            width: 413.9999694824219 * horizontalScale,
            height: 413.9999694824219 * verticalScale,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              color: Color.fromRGBO(122, 98, 222, 1),
            ),
          ),
        ),
        Positioned(
          top: 137 * verticalScale,
          left: 348 * horizontalScale,
          child: Container(
            width: 161.99998474121094 * min(horizontalScale, verticalScale),
            height: 161.99998474121094 * min(horizontalScale, verticalScale),
            decoration: BoxDecoration(
              color: Color.fromRGBO(126, 106, 228, 1),
              borderRadius: BorderRadius.all(
                  Radius.elliptical(161.99998474121094, 161.99998474121094)),
            ),
          ),
        ),
        Positioned(
          top: -105.00000762939453 * verticalScale,
          left: -91.00000762939453 * horizontalScale,
          child: Container(
            width: 161.99998474121094 * min(horizontalScale, verticalScale),
            height: 161.99998474121094 * min(horizontalScale, verticalScale),
            decoration: BoxDecoration(
              color: Color.fromRGBO(126, 106, 228, 1),
              borderRadius: BorderRadius.all(
                  Radius.elliptical(161.99998474121094, 161.99998474121094)),
            ),
          ),
        ),
        Positioned(
          top: 102 * verticalScale,
          left: 102 * horizontalScale,
          child: Text(
            'My Courses',
            textAlign: TextAlign.center,
            textScaleFactor: min(horizontalScale, verticalScale),
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'Poppins',
                fontSize: 35,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
        ),
        courses.length > 0
            ? Positioned(
                top: 0 * verticalScale,
                left: 0 * horizontalScale,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('courses')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      return Container(
                        width: screenWidth,
                        height: screenHeight,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          // shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot document =
                                snapshot.data!.docs[index];
                            Map<String, dynamic> map =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            if (map["name"].toString() == "null") {
                              return Container();
                            }
                            if (courses.contains(map['id'])) {
                              return Stack(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 230 * verticalScale,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                            width: 176.99998474121094 *
                                                horizontalScale,
                                            height: 91.99999237060547 *
                                                verticalScale,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25),
                                                bottomLeft: Radius.circular(0),
                                                bottomRight: Radius.circular(0),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color.fromRGBO(
                                                        29,
                                                        28,
                                                        31,
                                                        0.30000001192092896),
                                                    offset: Offset(2, 2),
                                                    blurRadius: 47)
                                              ],
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    map['image_url'].toString(),
                                                  ),
                                                  fit: BoxFit.fitWidth),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Stack(
                                            children: [
                                              Container(
                                                width: 177 * horizontalScale,
                                                height: 200 * verticalScale / 2,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    // topLeft: Radius.circular(25),
                                                    // topRight: Radius.circular(25),
                                                    bottomLeft:
                                                        Radius.circular(25),
                                                    bottomRight:
                                                        Radius.circular(25),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Color.fromRGBO(
                                                            29,
                                                            28,
                                                            31,
                                                            0.30000001192092896),
                                                        offset: Offset(2, 2),
                                                        blurRadius: 47)
                                                  ],
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                              ),
                                              Positioned(
                                                top: 5 * verticalScale,
                                                left: 10 * horizontalScale,
                                                right: 10 * horizontalScale,
                                                child: Container(
                                                  child: Text(
                                                    map['name'],
                                                    textScaleFactor:
                                                        horizontalScale,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 1),
                                                        fontFamily: 'Poppins',
                                                        fontSize: 15,
                                                        letterSpacing:
                                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1),
                                                    // overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              map['combo'] &&
                                                      statusOfPayInParts(
                                                          map['id'])
                                                  ? Positioned(
                                                      top: 35 * verticalScale,
                                                      left:
                                                          10 * horizontalScale,
                                                      child: Container(
                                                        child:
                                                            !navigateToCatalogueScreen(
                                                                    map['id'])
                                                                ? Container(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.08 *
                                                                        verticalScale,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Color(
                                                                          0xFFC0AAF5),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          'Access ends in days : ',
                                                                          textScaleFactor: min(
                                                                              horizontalScale,
                                                                              verticalScale),
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Colors.grey.shade100),
                                                                          width:
                                                                              30 * min(horizontalScale, verticalScale),
                                                                          height:
                                                                              30 * min(horizontalScale, verticalScale),
                                                                          // color:
                                                                          //     Color(0xFFaefb2a),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              '${(DateTime.parse(userMap['payInPartsDetails'][map['id']]['endDateOfLimitedAccess']).difference(DateTime.now()).inDays)}',
                                                                              textScaleFactor: min(horizontalScale, verticalScale),
                                                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold
                                                                                  // fontSize: 16,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.08,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Color(
                                                                          0xFFC0AAF5),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Limited access expired !',
                                                                        textScaleFactor: min(
                                                                            horizontalScale,
                                                                            verticalScale),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.deepOrange[600],
                                                                          fontSize:
                                                                              13,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 395 * verticalScale,
                                      ),
                                      map['combo']
                                          ? Row(
                                              children: [
                                                SizedBox(
                                                  width: 30 * horizontalScale,
                                                ),
                                                Stack(
                                                  children: [
                                                    Positioned(
                                                      // top: 70 * verticalScale,
                                                      // left: 10 * horizontalScale,
                                                      child: Container(
                                                        width: 60 *
                                                            horizontalScale,
                                                        height:
                                                            40 * verticalScale,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              Color(0xFF7860DC),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'COMBO',
                                                            textScaleFactor: min(
                                                                horizontalScale,
                                                                verticalScale),
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Bold',
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      );
                    }),
              )
            : Container(),
        // Positioned(
        //   // top: 227 * verticalScale,
        //   // left: 20,
        //   child: StreamBuilder<QuerySnapshot>(
        //     stream:
        //         FirebaseFirestore.instance.collection('courses').snapshots(),
        //     builder:
        //         (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //       if (!snapshot.hasData) return const SizedBox.shrink();
        //       return Container(
        //         width: screenWidth,
        //         height: screenHeight,
        //         child: ListView.builder(
        //           shrinkWrap: true,
        //           scrollDirection: Axis.horizontal,
        //           itemCount: snapshot.data!.docs.length,
        //           itemBuilder: (BuildContext context, index) {
        //             DocumentSnapshot document = snapshot.data!.docs[index];
        //             Map<String, dynamic> map = snapshot.data!.docs[index].data()
        //                 as Map<String, dynamic>;
        //             // setState(() {
        //             //   id= map['id'];
        //             // });
        //             if (map["name"].toString() == "null") {
        //               return Container();
        //             }
        //             if (courses.contains(map['id'])) {
        //               return InkWell(
        //                 onTap: () {
        //                   // if()
        //                   if (navigateToCatalogueScreen(map['id']) &&
        //                       !(userMap['payInPartsDetails'][map['id']]
        //                           ['outStandingAmtPaid'])) {
        //                     if (!map['combo']) {
        //                       Navigator.push(
        //                         context,
        //                         PageTransition(
        //                             duration: Duration(milliseconds: 100),
        //                             curve: Curves.bounceInOut,
        //                             type: PageTransitionType.rightToLeft,
        //                             child: CatelogueScreen()),
        //                       );
        //                     } else {
        //                       Navigator.push(
        //                         context,
        //                         PageTransition(
        //                           duration: Duration(milliseconds: 100),
        //                           curve: Curves.bounceInOut,
        //                           type: PageTransitionType.rightToLeft,
        //                           child: ComboStore(
        //                             courses: map['courses'],
        //                           ),
        //                         ),
        //                       );
        //                     }
        //                   } else {
        //                     if (!map['combo']) {
        //                       Navigator.push(
        //                         context,
        //                         PageTransition(
        //                             duration: Duration(milliseconds: 400),
        //                             curve: Curves.bounceInOut,
        //                             type: PageTransitionType.rightToLeft,
        //                             child: Couse()),
        //                       );
        //                     } else {
        //                       ComboCourse.comboId.value = map['id'];
        //                       Navigator.push(
        //                         context,
        //                         PageTransition(
        //                           duration: Duration(milliseconds: 400),
        //                           curve: Curves.bounceInOut,
        //                           type: PageTransitionType.rightToLeft,
        //                           child: ComboCourse(
        //                             courses: map['courses'],
        //                           ),
        //                         ),
        //                       );
        //                     }
        //                   }
        //                   setState(() {
        //                     courseId = snapshot.data!.docs[index].id;
        //                   });
        //                 },
        //                 child: Stack(
        //                   children: <Widget>[
        //                     Row(
        //                       children: [
        //                         SizedBox(
        //                           width: 20 * horizontalScale,
        //                         ),
        //                         Column(
        //                           children: [
        //                             SizedBox(
        //                               height: 227 * verticalScale,
        //                             ),
        //                             Positioned(
        //                               child: Container(
        //                                 height: 109 * verticalScale,
        //                                 width: 187 * horizontalScale,
        //                                 decoration: BoxDecoration(
        //                                   boxShadow: [
        //                                     BoxShadow(
        //                                         color: Color.fromRGBO(29, 28,
        //                                             30, 0.30000001192092896),
        //                                         offset: Offset(2, 2),
        //                                         // spreadRadius: 5,
        //                                         blurStyle: BlurStyle.outer,
        //                                         blurRadius: 15)
        //                                   ],
        //                                 ),
        //                                 child: ClipRRect(
        //                                   borderRadius: BorderRadius.only(
        //                                     topLeft: Radius.circular(25),
        //                                     topRight: Radius.circular(25),
        //                                   ),
        //                                   child: Image.network(
        //                                     map['image_url'].toString(),
        //                                     fit: BoxFit.cover,
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ],
        //                     ),
        //                     Row(
        //                       children: [
        //                         SizedBox(
        //                           width: 20 * horizontalScale,
        //                         ),
        //                         Column(
        //                           children: [
        //                             SizedBox(
        //                               height: 336 * verticalScale,
        //                             ),
        //                             Stack(
        //                               children: [
        //                                 Container(
        //                                   height: 109 * verticalScale,
        //                                   width: 187 * horizontalScale,
        //                                   decoration: BoxDecoration(
        //                                     color: Colors.white,
        //                                     borderRadius: BorderRadius.only(
        //                                       bottomLeft: Radius.circular(25),
        //                                       bottomRight: Radius.circular(25),
        //                                     ),
        //                                     boxShadow: [
        //                                       BoxShadow(
        //                                           color: Color.fromRGBO(29, 28,
        //                                               30, 0.30000001192092896),
        //                                           offset: Offset(2, 2),
        //                                           blurStyle: BlurStyle.outer,
        //                                           blurRadius: 15)
        //                                     ],
        //                                   ),
        //                                 ),
        //                                 Column(
        //                                   children: [
        //                                     SizedBox(
        //                                       height: 5 * verticalScale,
        //                                     ),
        //                                     Row(
        //                                       children: [
        //                                         SizedBox(
        //                                           width: 10 * horizontalScale,
        //                                         ),
        //                                         Container(
        //                                           width: 180 * horizontalScale,
        //                                           // height: 30* verticalScale,
        //                                           child: Text(
        //                                             map["name"],
        //                                             textScaleFactor: min(
        //                                                 horizontalScale,
        //                                                 verticalScale),
        //                                             style: const TextStyle(
        //                                                 fontFamily: 'Bold',
        //                                                 fontSize: 15,
        //                                                 fontWeight:
        //                                                     FontWeight.w500),
        //                                             // overflow: TextOverflow.ellipsis,
        //                                           ),
        //                                         ),
        //                                         SizedBox(
        //                                           width: 0,
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ],
        //                                 ),
        //                                 map['combo']
        //                                     ? Row(
        //                                         children: [
        //                                           SizedBox(
        //                                             width: 15 * horizontalScale,
        //                                           ),
        //                                           Column(
        //                                             children: [
        //                                               SizedBox(
        //                                                 height:
        //                                                     90 * verticalScale,
        //                                               ),
        //                                               Container(
        //                                                 width: 60 *
        //                                                     horizontalScale,
        //                                                 height:
        //                                                     40 * verticalScale,
        //                                                 decoration:
        //                                                     BoxDecoration(
        //                                                   borderRadius:
        //                                                       BorderRadius
        //                                                           .circular(10),
        //                                                   color:
        //                                                       Color(0xFF7860DC),
        //                                                 ),
        //                                                 child: Center(
        //                                                   child: Text(
        //                                                     'COMBO',
        //                                                     textScaleFactor: min(
        //                                                         horizontalScale,
        //                                                         verticalScale),
        //                                                     style:
        //                                                         const TextStyle(
        //                                                       fontFamily:
        //                                                           'Bold',
        //                                                       fontSize: 13,
        //                                                       fontWeight:
        //                                                           FontWeight
        //                                                               .w500,
        //                                                       color:
        //                                                           Colors.white,
        //                                                     ),
        //                                                   ),
        //                                                 ),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                         ],
        //                                       )
        //                                     : Positioned(
        //                                         child: Container(),
        //                                       ),
        //                                 map['combo'] &&
        //                                         statusOfPayInParts(map['id'])
        //                                     ? Row(
        //                                         children: [
        //                                           SizedBox(
        //                                             width: 10 * horizontalScale,
        //                                           ),
        //                                           Column(
        //                                             children: [
        //                                               SizedBox(
        //                                                 height:
        //                                                     55 * verticalScale,
        //                                               ),
        //                                               Container(
        //                                                 child:
        //                                                     !navigateToCatalogueScreen(
        //                                                             map['id'])
        //                                                         ? Container(
        //                                                             height: MediaQuery.of(context)
        //                                                                     .size
        //                                                                     .width *
        //                                                                 0.08 *
        //                                                                 verticalScale,
        //                                                             decoration:
        //                                                                 BoxDecoration(
        //                                                               borderRadius:
        //                                                                   BorderRadius.circular(
        //                                                                       10),
        //                                                               color: Color(
        //                                                                   0xFFC0AAF5),
        //                                                             ),
        //                                                             child: Row(
        //                                                               mainAxisAlignment:
        //                                                                   MainAxisAlignment
        //                                                                       .spaceEvenly,
        //                                                               children: [
        //                                                                 SizedBox(
        //                                                                   width:
        //                                                                       10,
        //                                                                 ),
        //                                                                 Text(
        //                                                                   'Access ends in days : ',
        //                                                                   textScaleFactor: min(
        //                                                                       horizontalScale,
        //                                                                       verticalScale),
        //                                                                   style: TextStyle(
        //                                                                       color: Colors.white,
        //                                                                       fontSize: 13,
        //                                                                       fontWeight: FontWeight.bold),
        //                                                                 ),
        //                                                                 Container(
        //                                                                   decoration: BoxDecoration(
        //                                                                       borderRadius: BorderRadius.circular(10),
        //                                                                       color: Colors.grey.shade100),
        //                                                                   width:
        //                                                                       30 * min(horizontalScale, verticalScale),
        //                                                                   height:
        //                                                                       30 * min(horizontalScale, verticalScale),
        //                                                                   // color:
        //                                                                   //     Color(0xFFaefb2a),
        //                                                                   child:
        //                                                                       Center(
        //                                                                     child:
        //                                                                         Text(
        //                                                                       '${(DateTime.parse(userMap['payInPartsDetails'][map['id']]['endDateOfLimitedAccess']).difference(DateTime.now()).inDays)}',
        //                                                                       textScaleFactor: min(horizontalScale, verticalScale),
        //                                                                       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold
        //                                                                           // fontSize: 16,
        //                                                                           ),
        //                                                                     ),
        //                                                                   ),
        //                                                                 ),
        //                                                               ],
        //                                                             ),
        //                                                           )
        //                                                         : Container(
        //                                                             height: MediaQuery.of(context)
        //                                                                     .size
        //                                                                     .width *
        //                                                                 0.08,
        //                                                             decoration:
        //                                                                 BoxDecoration(
        //                                                               borderRadius:
        //                                                                   BorderRadius.circular(
        //                                                                       10),
        //                                                               color: Color(
        //                                                                   0xFFC0AAF5),
        //                                                             ),
        //                                                             child:
        //                                                                 Center(
        //                                                               child:
        //                                                                   Text(
        //                                                                 'Limited access expired !',
        //                                                                 textScaleFactor: min(
        //                                                                     horizontalScale,
        //                                                                     verticalScale),
        //                                                                 style:
        //                                                                     TextStyle(
        //                                                                   color:
        //                                                                       Colors.deepOrange[600],
        //                                                                   fontSize:
        //                                                                       13,
        //                                                                 ),
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                         ],
        //                                       )
        //                                     : Positioned(
        //                                         child: Container(),
        //                                       ),
        //                               ],
        //                             ),
        //                           ],
        //                         ),
        //                       ],
        //                     ),
        //                   ],
        //                 ),
        //               );
        //             } else {
        //               return Container();
        //             }
        //           },
        //         ),
        //       );
        //     },
        //   ),
        // ),
        Positioned(
          top: 498 * verticalScale,
          left: 36 * horizontalScale,
          child: Text(
            'Popular Courses',
            textAlign: TextAlign.left,
            textScaleFactor: min(horizontalScale, verticalScale),
            style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                fontSize: 24,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                height: 1),
          ),
        ),
        Positioned(
          top: 530 * verticalScale,
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('courses').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(top: 8.0 * verticalScale),
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.4,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        if (map["name"].toString() == "null") {
                          return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                courseId = document.id;
                              });

                              print(courseId);
                              if (map['combo']) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ComboStore(
                                      courses: map['courses'],
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CatelogueScreen(),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.09),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  // height: MediaQuery.of(context).size.height * 0.16,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFE9E1FC),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //       color: Color.fromRGBO(
                                    //           29, 28, 30, 0.30000001192092896),
                                    //       offset: Offset(2, 2),
                                    //       // spreadRadius: 5,
                                    //       blurStyle: BlurStyle.outer,
                                    //       blurRadius: 35)
                                    // ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 100 *
                                              min(horizontalScale,
                                                  verticalScale),
                                          width: 100 *
                                              min(horizontalScale,
                                                  verticalScale),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                map['image_url'].toString(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            map['combo'] == true
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        gradient: gradient),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        'COMBO',
                                                        textScaleFactor: min(
                                                            horizontalScale,
                                                            verticalScale),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'SemiBold',
                                                            fontSize: 8,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            Container(
                                              // width: MediaQuery.of(context)
                                              //         .size
                                              //         .width *
                                              //     0.45,
                                              child: Text(
                                                map["name"],
                                                textScaleFactor: min(
                                                    horizontalScale,
                                                    verticalScale),
                                                style: const TextStyle(
                                                    fontFamily: 'Bold',
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                // maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      map["language"],
                                                      textScaleFactor: min(
                                                          horizontalScale,
                                                          verticalScale),
                                                      style: TextStyle(
                                                          fontFamily: 'Medium',
                                                          color: Colors.black
                                                              .withOpacity(0.4),
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Container(
                                                    child: Center(
                                                      child: Text(
                                                        '${map['videosCount']} videos',
                                                        textScaleFactor: min(
                                                            horizontalScale,
                                                            verticalScale),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Medium',
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 80,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              map['Course Price'],
                                              textScaleFactor: min(
                                                  horizontalScale,
                                                  verticalScale),
                                              style: TextStyle(
                                                  fontFamily: 'Bold',
                                                  color: Color(0xFF6E5BD9),
                                                  fontSize: 17),
                                            ),
                                            // SizedBox(
                                            //   width: 40,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 100 * verticalScale,
          left: 63 * horizontalScale,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_sharp,
                color: Colors.white,
                size: 40 * min(horizontalScale, verticalScale)),
          ),
        ),
      ],
    ));
  }
}
