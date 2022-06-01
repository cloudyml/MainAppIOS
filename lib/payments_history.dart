import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List<dynamic> courses = [];

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
    print('The courses are--$courses');
  }

  Map userMap = Map<String, dynamic>();
  void dbCheckerForPayInParts() async {
    DocumentSnapshot userDocs = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      userMap = userDocs.data() as Map<String, dynamic>;
    });
    print('Usermap is--$userMap');
  }

  void initState() {
    super.initState();
    fetchCourses();
    dbCheckerForPayInParts();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -147.00001525878906 * verticalScale,
            left: 0,
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
            top: 115 * verticalScale,
            left: 63 * horizontalScale,
            child: Text(
              'Payment History',
              textAlign: TextAlign.center,
              textScaleFactor: min(horizontalScale, verticalScale),
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Poppins',
                  fontSize: 35,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.w500,
                  height: 1),
            ),
          ),
          Positioned(
            top: 26.000001907348633 * verticalScale,
            left: 294.0000305175781 * horizontalScale,
            child: Container(
              width: 29.999998092651367 * min(horizontalScale, verticalScale),
              height: 29.999998092651367 * min(horizontalScale, verticalScale),
              decoration: BoxDecoration(
                color: Color.fromRGBO(127, 106, 228, 1),
                borderRadius: BorderRadius.all(
                    Radius.elliptical(29.999998092651367, 29.999998092651367)),
              ),
            ),
          ),
          Positioned(
            top: 101.00000762939453 * verticalScale,
            left: 358.0000305175781 * horizontalScale,
            child: Container(
              width: 19.999998092651367 * min(horizontalScale, verticalScale),
              height: 19.999998092651367 * min(horizontalScale, verticalScale),
              decoration: BoxDecoration(
                color: Color.fromRGBO(127, 106, 228, 1),
                borderRadius: BorderRadius.all(
                    Radius.elliptical(19.999998092651367, 19.999998092651367)),
              ),
            ),
          ),
          Positioned(
            top: 206.00001525878906 * verticalScale,
            left: 378.0000305175781 * horizontalScale,
            child: Container(
              width: 7.999999523162842 * min(horizontalScale, verticalScale),
              height: 7.999999523162842 * min(horizontalScale, verticalScale),
              decoration: BoxDecoration(
                color: Color.fromRGBO(127, 106, 228, 1),
                borderRadius: BorderRadius.all(
                  Radius.elliptical(7.999999523162842, 7.999999523162842),
                ),
              ),
            ),
          ),
          Positioned(
            top: 179.00001525878906 * verticalScale,
            left: 310.0000305175781 * horizontalScale,
            child: Container(
              width: 13.999999046325684 * min(horizontalScale, verticalScale),
              height: 14.999999046325684 * min(horizontalScale, verticalScale),
              decoration: BoxDecoration(
                color: Color.fromRGBO(127, 106, 228, 1),
                borderRadius: BorderRadius.all(
                  Radius.elliptical(13.999999046325684, 14.999999046325684),
                ),
              ),
            ),
          ),
          Positioned(
            top: 209.00001525878906 * verticalScale,
            left: 72.00000762939453 * horizontalScale,
            child: Container(
              width: 270.9999694824219 * horizontalScale,
              height: 106.99999237060547 * verticalScale,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(29, 28, 31, 0.30000001192092896),
                      offset: Offset(2, 2),
                      blurRadius: 50)
                ],
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
          Positioned(
            top: 270 * verticalScale,
            left: 111.00000762939453 * horizontalScale,
            child: Text(
              'Successful',
              textAlign: TextAlign.left,
              textScaleFactor: horizontalScale,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          Positioned(
            top: 232.00001525878906 * verticalScale,
            left: 133.00001525878906 * horizontalScale,
            child: Container(
                width: 37 * min(horizontalScale, verticalScale),
                height: 37 * min(horizontalScale, verticalScale),
                decoration: BoxDecoration(
                  color: Color(0xFF14F5A4),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                )),
          ),
          Positioned(
            top: 270.0000305175781 * verticalScale,
            left: 239.00001525878906 * horizontalScale,
            child: Text(
              'Pending',
              textAlign: TextAlign.left,
              textScaleFactor: horizontalScale,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          Positioned(
            top: 232.00001525878906 * verticalScale,
            right: 133.00001525878906 * horizontalScale,
            child: Container(
                width: 37 * min(horizontalScale, verticalScale),
                height: 37 * min(horizontalScale, verticalScale),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(241, 54, 88, 1),
                  borderRadius: BorderRadius.all(
                      Radius.elliptical(32.99998092651367, 32.99998092651367)),
                ),
                child: Icon(
                  CupertinoIcons.exclamationmark,
                  color: Colors.white,
                )),
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
                                          height: 345 * verticalScale,
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
                                                  bottomLeft:
                                                      Radius.circular(0),
                                                  bottomRight:
                                                      Radius.circular(0),
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
                                                      map['image_url']
                                                          .toString(),
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
                                                  height:
                                                      200 * verticalScale / 2,
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
                                                Positioned(
                                                  top: 35 * verticalScale,
                                                  left: 10 * horizontalScale,
                                                  right: 40 * horizontalScale,
                                                  child: Divider(
                                                    thickness: 1.5,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 50 * verticalScale,
                                                  left: 10 * horizontalScale,
                                                  right: 10 * horizontalScale,
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Amount Paid : ',
                                                          textScaleFactor:
                                                              horizontalScale,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFC0AAF5),
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1),
                                                          // overflow: TextOverflow.ellipsis,
                                                        ),
                                                        Text(
                                                          map['Course Price'],
                                                          textScaleFactor:
                                                              horizontalScale,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFC0AAF5),
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1),
                                                          // overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 65 * verticalScale,
                                                  left: 10 * horizontalScale,
                                                  right: 10 * horizontalScale,
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Offers : ',
                                                          textScaleFactor:
                                                              horizontalScale,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFC0AAF5),
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1),
                                                          // overflow: TextOverflow.ellipsis,
                                                        ),
                                                        userMap['couponCodeDetails']
                                                                    [
                                                                    map['id']] ==
                                                                null
                                                            ? Text(
                                                                'none',
                                                                textScaleFactor:
                                                                    horizontalScale,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFFC0AAF5),
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        12,
                                                                    letterSpacing:
                                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 1),
                                                                // overflow: TextOverflow.ellipsis,
                                                              )
                                                            : Text(
                                                                userMap['couponCodeDetails']
                                                                        [
                                                                        map['id']]
                                                                    [
                                                                    'couponCodeApplied'],
                                                                textScaleFactor:
                                                                    horizontalScale,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFFC0AAF5),
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        12,
                                                                    letterSpacing:
                                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 1),
                                                                // overflow: TextOverflow.ellipsis,
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 175 * horizontalScale,
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 510 *
                                                  min(horizontalScale,
                                                      verticalScale),
                                            ),
                                            userMap['payInPartsDetails'][map['id']] !=
                                                        null &&
                                                    !userMap['payInPartsDetails']
                                                            [map['id']]
                                                        ['outStandingAmtPaid']
                                                ? Container(
                                                    width: 37 *
                                                        min(horizontalScale,
                                                            verticalScale),
                                                    height: 37 *
                                                        min(horizontalScale,
                                                            verticalScale),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          241, 54, 88, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    child: Icon(
                                                      CupertinoIcons
                                                          .exclamationmark,
                                                      color: Colors.white,
                                                    ))
                                                : Container(
                                                    width: 37 *
                                                        min(horizontalScale,
                                                            verticalScale),
                                                    height: 37 *
                                                        min(horizontalScale,
                                                            verticalScale),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF14F5A4),
                                                      borderRadius: BorderRadius
                                                          .all(Radius.elliptical(
                                                              32.99998092651367,
                                                              32.99998092651367)),
                                                    ),
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                    )),
                                          ],
                                        ),
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
          Positioned(
            top: 586 * verticalScale,
            left: 20 * horizontalScale,
            child: Text(
              'Explore more',
              textAlign: TextAlign.left,
              textScaleFactor: min(horizontalScale, verticalScale),
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.w500,
                  height: 1),
            ),
          ),
          Positioned(
            top: 620 * verticalScale,
            // left: 20 * horizontalScale,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('courses').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
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
                                  builder: (context) => const CatelogueScreen(),
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
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 100 *
                                            min(horizontalScale, verticalScale),
                                        width: 100 *
                                            min(horizontalScale, verticalScale),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                map['image_url'].toString(),
                                              ),
                                              fit: BoxFit.fitHeight),
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
                                                          BorderRadius.circular(
                                                              30),
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
                                                          color: Colors.black),
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
                                              style: const TextStyle(
                                                  fontFamily: 'Bold',
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500),
                                              // maxLines: 2,
                                              textScaleFactor: min(
                                                  horizontalScale,
                                                  verticalScale),
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
                                                          fontFamily: 'Medium',
                                                          color: Colors.black
                                                              .withOpacity(0.7),
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
                                                horizontalScale, verticalScale),
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
                                    SizedBox(
                                      width: 10,
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
                );
              },
            ),
          ),
          Positioned(
            top: 110 * verticalScale,
            left: 25 * horizontalScale,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_outlined,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
