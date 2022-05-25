import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/combo/combo_course.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/course.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
        // appBar: AppBar(title:Text('My Courses'),elevation: 0,centerTitle: true,),
        //   backgroundColor: Colors.white,
        body: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: 414,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -147.00001525878906,
                    left: 2.384185791015625e-7,
                    child: Container(
                      width: 413.9999694824219,
                      height: 413.9999694824219,
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
                    top: 137.00001525878906,
                    left: 318.0000305175781,
                    child: Container(
                      width: 161.99998474121094,
                      height: 161.99998474121094,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(126, 106, 228, 1),
                        borderRadius: BorderRadius.all(Radius.elliptical(
                            161.99998474121094, 161.99998474121094)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -105.00000762939453,
                    left: -94.00000762939453,
                    child: Container(
                      width: 161.99998474121094,
                      height: 161.99998474121094,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(126, 106, 228, 1),
                        borderRadius: BorderRadius.all(Radius.elliptical(
                            161.99998474121094, 161.99998474121094)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 142.00001525878906,
                    left: 102.00000762939453,
                    child: Text(
                      'My Courses',
                      textAlign: TextAlign.center,
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
                  Positioned(
                    top: 142.00001525878906,
                    left: 62.00000762939453,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.275,
              // left: MediaQuery.of(context).size.width * 0.1,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        // setState(() {
                        //   id= map['id'];
                        // });
                        if (map["name"].toString() == "null") {
                          return Container();
                        }
                        if (courses.contains(map['id'])) {
                          return InkWell(
                            onTap: () {
                              // if()
                              if (navigateToCatalogueScreen(map['id']) &&
                                  !(userMap['payInPartsDetails'][map['id']]
                                      ['outStandingAmtPaid'])) {
                                if (!map['combo']) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        duration: Duration(milliseconds: 100),
                                        curve: Curves.bounceInOut,
                                        type: PageTransitionType.rightToLeft,
                                        child: CatelogueScreen()),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.bounceInOut,
                                      type: PageTransitionType.rightToLeft,
                                      child: ComboStore(
                                        courses: map['courses'],
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                if (!map['combo']) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        duration: Duration(milliseconds: 400),
                                        curve: Curves.bounceInOut,
                                        type: PageTransitionType.rightToLeft,
                                        child: Couse()),
                                  );
                                } else {
                                  ComboCourse.comboId.value = map['id'];
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.bounceInOut,
                                      type: PageTransitionType.rightToLeft,
                                      child: ComboCourse(
                                        courses: map['courses'],
                                      ),
                                    ),
                                  );
                                }
                              }
                              setState(() {
                                courseId = snapshot.data!.docs[index].id;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.12),
                              child: Container(
                                width: 221.00001525878906,
                                height: 227.00001525878906,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        width: 220.99998474121094,
                                        height: 226.99998474121094,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25),
                                            bottomLeft: Radius.circular(25),
                                            bottomRight: Radius.circular(25),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromRGBO(29, 28,
                                                    30, 0.30000001192092896),
                                                offset: Offset(2, 2),
                                                // spreadRadius: 5,
                                                blurStyle: BlurStyle.outer,
                                                blurRadius: 15)
                                          ],
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 20,
                                      left: 20,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.13,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.22,
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
                                    Positioned(
                                      top: MediaQuery.of(context).size.width *
                                          0.31,
                                      left: MediaQuery.of(context).size.width *
                                          0.05,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: Text(
                                          map["name"],
                                          style: const TextStyle(
                                              fontFamily: 'Bold',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    map['combo']
                                        ? Stack(
                                            children: [
                                              Positioned(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.51,
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.08,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Color(0xFF7860DC),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'COMBO',
                                                      style: const TextStyle(
                                                        fontFamily: 'Bold',
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              statusOfPayInParts(map['id'])
                                                  ? Positioned(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.41,
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: Container(
                                                        // width: MediaQuery.of(
                                                        //             context)
                                                        //         .size
                                                        //         .width *
                                                        //     0.45,
                                                        child:
                                                            !navigateToCatalogueScreen(
                                                                    map['id'])
                                                                ? Container(
                                                                    // width: MediaQuery.of(context)
                                                                    //         .size
                                                                    //         .width *
                                                                    //     0.3,
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
                                                                              30,
                                                                          height:
                                                                              30,
                                                                          // color:
                                                                          //     Color(0xFFaefb2a),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              '${(DateTime.parse(userMap['payInPartsDetails'][map['id']]['endDateOfLimitedAccess']).difference(DateTime.now()).inDays)}',
                                                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold
                                                                                  // fontSize: 16,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Positioned(
                                                                    top: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.41,
                                                                    left: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.05,
                                                                    child:
                                                                        Container(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.08,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: Color(
                                                                            0xFFC0AAF5),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'Limited access expired !',
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
                                                      ),
                                                    )
                                                  : Positioned(
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                      ),
                                                    ),
                                            ],
                                          )
                                        : Positioned(
                                            child: Container(),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.58,
              left: MediaQuery.of(context).size.width * 0.1,
              child: Text(
                'Popular Courses',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    height: 1),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.6,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
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
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  // height: MediaQuery.of(context).size.height * 0.16,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.10,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.13,
                                          child: Image.network(
                                            map['image_url'].toString(),
                                            fit: BoxFit.cover,
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
                  );
                },
              ),
            ),
          ],
        ),

        // load!
        //     ? CircularProgressIndicator()
        //     : Expanded(
        //         child: StreamBuilder<QuerySnapshot>(
        //           stream: FirebaseFirestore.instance
        //               .collection('courses')
        //               .snapshots(),
        //           builder: (BuildContext context,
        //               AsyncSnapshot<QuerySnapshot> snapshot) {
        //             if (!snapshot.hasData) return const SizedBox.shrink();
        //             return ListView.builder(
        //               itemCount: snapshot.data!.docs.length,
        //               itemBuilder: (BuildContext context, index) {
        //                 DocumentSnapshot document = snapshot.data!.docs[index];
        //                 Map<String, dynamic> map = snapshot.data!.docs[index]
        //                     .data() as Map<String, dynamic>;
        //                 // setState(() {
        //                 //   id= map['id'];
        //                 // });
        //                 if (map["name"].toString() == "null") {
        //                   return Container();
        //                 }
        //                 if (courses.contains(map['id'])) {
        //                   return InkWell(
        //                     onTap: () {
        //                       // if()
        //                       if (navigateToCatalogueScreen(map['id']) &&
        //                           !(userMap['payInPartsDetails'][map['id']]
        //                               ['outStandingAmtPaid'])) {
        //                         if (!map['combo']) {
        //                           Navigator.push(
        //                             context,
        //                             PageTransition(
        //                                 duration: Duration(milliseconds: 100),
        //                                 curve: Curves.bounceInOut,
        //                                 type: PageTransitionType.rightToLeft,
        //                                 child: CatelogueScreen()),
        //                           );
        //                         } else {
        //                           Navigator.push(
        //                             context,
        //                             PageTransition(
        //                               duration: Duration(milliseconds: 100),
        //                               curve: Curves.bounceInOut,
        //                               type: PageTransitionType.rightToLeft,
        //                               child: ComboStore(
        //                                 courses: map['courses'],
        //                               ),
        //                             ),
        //                           );
        //                         }
        //                       } else {
        //                         if (!map['combo']) {
        //                           Navigator.push(
        //                             context,
        //                             PageTransition(
        //                                 duration: Duration(milliseconds: 400),
        //                                 curve: Curves.bounceInOut,
        //                                 type: PageTransitionType.rightToLeft,
        //                                 child: Couse()),
        //                           );
        //                         } else {
        //                           ComboCourse.comboId.value = map['id'];
        //                           Navigator.push(
        //                             context,
        //                             PageTransition(
        //                               duration: Duration(milliseconds: 400),
        //                               curve: Curves.bounceInOut,
        //                               type: PageTransitionType.rightToLeft,
        //                               child: ComboCourse(
        //                                 courses: map['courses'],
        //                               ),
        //                             ),
        //                           );
        //                         }
        //                       }
        //                       setState(() {
        //                         courseId = snapshot.data!.docs[index].id;
        //                       });
        //                     },
        //                     child: Padding(
        //                       padding: const EdgeInsets.symmetric(
        //                           horizontal: 18.0, vertical: 10),
        //                       child: ClipRRect(
        //                         borderRadius: BorderRadius.circular(28),
        //                         child: Container(
        //                           height:
        //                               MediaQuery.of(context).size.height * 0.25,
        //                           width: MediaQuery.of(context).size.width,
        //                           decoration: BoxDecoration(
        //                             borderRadius: BorderRadius.circular(28),
        //                             color: Colors.grey.shade200,
        //                           ),
        //                           child: Row(
        //                             mainAxisAlignment: MainAxisAlignment.start,
        //                             children: [
        //                               Container(
        //                                 height:
        //                                     MediaQuery.of(context).size.height *
        //                                         0.22,
        //                                 width:
        //                                     MediaQuery.of(context).size.height *
        //                                         0.15,
        //                                 child: Image.network(
        //                                   map['image_url'].toString(),
        //                                   fit: BoxFit.cover,
        //                                 ),
        //                               ),
        //                               SizedBox(
        //                                 width: 10,
        //                               ),
        //                               Padding(
        //                                 padding: const EdgeInsets.all(18.0),
        //                                 child: Column(
        //                                   crossAxisAlignment:
        //                                       CrossAxisAlignment.start,
        //                                   children: [
        //                                     map['combo'] == true
        //                                         ? Container(
        //                                             decoration: BoxDecoration(
        //                                                 borderRadius:
        //                                                     BorderRadius
        //                                                         .circular(30),
        //                                                 gradient: gradient),
        //                                             child: Padding(
        //                                               padding:
        //                                                   const EdgeInsets.all(
        //                                                       4.0),
        //                                               child: Text(
        //                                                 'COMBO',
        //                                                 style: TextStyle(
        //                                                     fontFamily:
        //                                                         'SemiBold',
        //                                                     fontSize: 10,
        //                                                     color:
        //                                                         Colors.black),
        //                                               ),
        //                                             ),
        //                                           )
        //                                         : Container(),
        //                                     Container(
        //                                       width: MediaQuery.of(context)
        //                                               .size
        //                                               .width *
        //                                           0.45,
        //                                       child: Text(
        //                                         map["name"],
        //                                         style: const TextStyle(
        //                                             fontFamily: 'Bold',
        //                                             fontSize: 20,
        //                                             fontWeight:
        //                                                 FontWeight.w500),
        //                                         overflow: TextOverflow.ellipsis,
        //                                       ),
        //                                     ),
        //                                     SizedBox(
        //                                       height: 10,
        //                                     ),
        //                                     Container(
        //                                       width: MediaQuery.of(context)
        //                                               .size
        //                                               .width *
        //                                           0.45,
        //                                       child: Row(
        //                                         mainAxisAlignment:
        //                                             MainAxisAlignment
        //                                                 .spaceBetween,
        //                                         children: [
        //                                           Container(
        //                                             child: Text(
        //                                               map["language"],
        //                                               style: TextStyle(
        //                                                   fontFamily: 'Medium',
        //                                                   color: Colors.black
        //                                                       .withOpacity(0.4),
        //                                                   fontSize: 11,
        //                                                   fontWeight:
        //                                                       FontWeight.w500),
        //                                             ),
        //                                           ),
        //                                           SizedBox(
        //                                             width: 4,
        //                                           ),
        //                                           Container(
        //                                             height: 30,
        //                                             width: 100,
        //                                             decoration: BoxDecoration(
        //                                                 borderRadius:
        //                                                     BorderRadius
        //                                                         .circular(20),
        //                                                 color: Colors
        //                                                     .grey.shade300),
        //                                             child: Center(
        //                                               child: Text(
        //                                                 '${map['videosCount']} videos',
        //                                                 style: TextStyle(
        //                                                     fontFamily:
        //                                                         'Medium',
        //                                                     color: Colors.black
        //                                                         .withOpacity(
        //                                                             0.7),
        //                                                     fontSize: 11),
        //                                               ),
        //                                             ),
        //                                           )
        //                                         ],
        //                                       ),
        //                                     ),
        //                                     SizedBox(
        //                                       height: 12,
        //                                     ),
        //                                     Container(
        //                                       width: MediaQuery.of(context)
        //                                               .size
        //                                               .width *
        //                                           0.45,
        //                                       child: Text(
        //                                         map['description'],
        //                                         overflow: TextOverflow.ellipsis,
        //                                         style: TextStyle(
        //                                             fontFamily: 'Regular',
        //                                             fontSize: 14,
        //                                             color: Colors.black),
        //                                       ),
        //                                     ),
        //                                     // Container(
        //                                     //   width: MediaQuery.of(context)
        //                                     //           .size
        //                                     //           .width *
        //                                     //       0.45,
        //                                     //   child: Text('Days left'),
        //                                     // ),
        //                                     // !userMap['payInPartsDetails']
        //                                     //                 [map['id']][
        //                                     //             'outStandingAmtPaid'] ||
        //                                     //         !(userMap['payInPartsDetails']
        //                                     //                     [map['id']] ==
        //                                     //             null)
        //                                     // (userMap['payInPartsDetails']
        //                                     //             [map['id']] ==
        //                                     //         null) ? false : (userMap['payInPartsDetails']
        //                                     //             [map['id']]['outStandingAmtPaid'])
        //                                     statusOfPayInParts(map['id'])
        //                                         ? Container(
        //                                             width:
        //                                                 MediaQuery.of(context)
        //                                                         .size
        //                                                         .width *
        //                                                     0.45,
        //                                             child:
        //                                                 !navigateToCatalogueScreen(
        //                                                         map['id'])
        //                                                     ? Container(
        //                                                         height: 40,
        //                                                         decoration: BoxDecoration(
        //                                                             borderRadius:
        //                                                                 BorderRadius.circular(
        //                                                                     10),
        //                                                             color: Colors
        //                                                                 .white),
        //                                                         child: Row(
        //                                                           mainAxisAlignment:
        //                                                               MainAxisAlignment
        //                                                                   .spaceEvenly,
        //                                                           children: [
        //                                                             Text(
        //                                                               'Access ends in days : ',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 color: Color(
        //                                                                     0xFFaefb2a),
        //                                                                 fontSize:
        //                                                                     16,
        //                                                               ),
        //                                                             ),
        //                                                             Container(
        //                                                               decoration: BoxDecoration(
        //                                                                   borderRadius: BorderRadius.circular(
        //                                                                       8),
        //                                                                   color: Colors
        //                                                                       .grey
        //                                                                       .shade100),
        //                                                               width: 30,
        //                                                               height:
        //                                                                   30,
        //                                                               // color:
        //                                                               //     Color(0xFFaefb2a),
        //                                                               child:
        //                                                                   Center(
        //                                                                 child:
        //                                                                     Text(
        //                                                                   '${(DateTime.parse(userMap['payInPartsDetails'][map['id']]['endDateOfLimitedAccess']).difference(DateTime.now()).inDays)}',
        //                                                                   style:
        //                                                                       TextStyle(
        //                                                                     color:
        //                                                                         Colors.deepOrange[600],
        //                                                                     // fontSize: 16,
        //                                                                   ),
        //                                                                 ),
        //                                                               ),
        //                                                             ),
        //                                                           ],
        //                                                         ),
        //                                                       )
        //                                                     : Container(
        //                                                         height: 40,
        //                                                         decoration: BoxDecoration(
        //                                                             borderRadius:
        //                                                                 BorderRadius.circular(
        //                                                                     10),
        //                                                             color: Colors
        //                                                                 .white),
        //                                                         child: Center(
        //                                                           child: Text(
        //                                                             'Limited access expired !',
        //                                                             style:
        //                                                                 TextStyle(
        //                                                               color: Colors
        //                                                                       .deepOrange[
        //                                                                   600],
        //                                                               fontSize:
        //                                                                   16,
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                       ),
        //                                           )
        //                                         : Container(
        //                                             width:
        //                                                 MediaQuery.of(context)
        //                                                         .size
        //                                                         .width *
        //                                                     0.45,
        //                                           ),
        //                                   ],
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   );
        //                 } else {
        //                   return Container();
        //                 }
        //               },
        //             );
        //           },
        //         ),
        //       ),
      ],
    ));
  }
}
