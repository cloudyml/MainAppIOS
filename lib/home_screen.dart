import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/combo/combo_course.dart';
import 'package:cloudyml_app2/course.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            load!
                ? CircularProgressIndicator()
                : Expanded(
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
                            DocumentSnapshot document =
                                snapshot.data!.docs[index];
                            Map<String, dynamic> map =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            if (map["name"].toString() == "null") {
                              return Container();
                            }
                            if (courses.contains(map['id'])) {
                              return InkWell(
                                onTap: () {
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
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.bounceInOut,
                                          type: PageTransitionType.rightToLeft,
                                          child: ComboCourse(
                                            courses: map['courses'],
                                          )),
                                    );
                                  }
                                  setState(() {
                                    courseId = snapshot.data!.docs[index].id;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
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
                                                0.22,
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
                                                map['combo'] == true
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            gradient: gradient),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Text(
                                                            'COMBO',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'SemiBold',
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45,
                                                  child: Text(
                                                    map["name"],
                                                    style: const TextStyle(
                                                        fontFamily: 'Bold',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                            overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
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
                                                              fontFamily:
                                                                  'Medium',
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.4),
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
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
                                                                fontSize: 11),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                    child: Text(
                                                      map['description'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily: 'Regular',
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
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
                  ),
          ],
        ));
  }
}
