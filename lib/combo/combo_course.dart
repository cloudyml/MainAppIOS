import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/course.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:page_transition/page_transition.dart';

class ComboCourse extends StatefulWidget {
  final List<dynamic>? courses;
  // static String? comboId='';
  static ValueNotifier<String> comboId = ValueNotifier('');
  const ComboCourse({Key? key, this.courses}) : super(key: key);

  @override
  State<ComboCourse> createState() => _ComboCourseState();
}

class _ComboCourseState extends State<ComboCourse> {
  // bool statusOfPayInParts(String id) async {
  //   DocumentSnapshot userDocs = await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   Map userData = userDocs.data() as Map<String, dynamic>;

  //   bool returnbool;
  //   if (userData['payInPartsDetails'][id]['minAmtPaid'] == true) {
  //     if (userData['payInPartsDetails'][id]['outStandingAmtPaid'] == false) {
  //       returnbool = true;
  //     } else {
  //       returnbool = false;
  //     }
  //   } else {
  //     returnbool = false;
  //   }
  //   return returnbool;
  // }
  Map userMap = Map<String, dynamic>();
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

  bool allowAccessAfterFPOPIP(String? id) {
    if (userMap['payInPartsDetails'][id] != null) {
      return userMap['payInPartsDetails'][id]['outStandingAmtPaid'];
    } else {
      return false;
    }
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

  void initState() {
    super.initState();
    dbCheckerForPayInParts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 20),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: ComboCourse.comboId,
            builder: (BuildContext context, String value, Widget? child) {
              return Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('courses')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        if (map["name"].toString() == "null") {
                          return Container();
                        }
                        if (widget.courses!.contains(map['id'])) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  courseId = document.id;
                                });
                                if (userMap['payInPartsDetails'][map['id']]
                                        ['outStandingAmtPaid'] &&
                                    map['combo']) {
                                  print(map['id']);
                                }
                                if (!allowAccessAfterFPOPIP(value)) {
                                  if (navigateToCatalogueScreen(map['id']) &&
                                      map['id'] == 'CML2') {
                                    showToast(
                                        'To access this course you need pay the second part of the combo course');
                                    // Navigator.push(
                                    //   context,
                                    //   PageTransition(
                                    //     duration: Duration(milliseconds: 100),
                                    //     curve: Curves.bounceInOut,
                                    //     type: PageTransitionType.rightToLeft,
                                    //     child: ComboStore(
                                    //       courses: map['courses'],
                                    //     ),
                                    //   ),
                                    // );
                                  } else {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          duration: Duration(milliseconds: 100),
                                          curve: Curves.bounceInOut,
                                          type: PageTransitionType.rightToLeft,
                                          child: Couse()),
                                    );
                                  }
                                } else {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        duration: Duration(milliseconds: 100),
                                        curve: Curves.bounceInOut,
                                        type: PageTransitionType.rightToLeft,
                                        child: Couse()),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(28),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          child: Image.network(
                                            map['image_url'].toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45,
                                                  child: Text(
                                                    map["name"],
                                                    style: const TextStyle(
                                                        fontFamily: 'Bold',
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                child: Container(
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
                                                              fontFamily:
                                                                  'Medium',
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.4),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors
                                                                .grey.shade300),
                                                        child: Center(
                                                          child: Text(
                                                            '${map['videosCount']} videos',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Medium',
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.7),
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      height: 48,
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          gradient: gradient),
                                                      child: Center(
                                                        child: Text(
                                                          map['Amount Payable'],
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Bold',
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Text(
                                                      map['Course Price'],
                                                      style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontFamily: 'Bold',
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          fontSize: 15),
                                                    )
                                                  ],
                                                ),
                                              ),
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
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
