// ignore: import_of_legacy_library_into_null_safe
import 'dart:math';

import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/api/firebase_api.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloudyml_app2/store.dart';
import 'package:flutter/material.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:cloudyml_app2/models/firebase_file.dart';
import 'package:provider/provider.dart';
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
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth ,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(
                        0,
                        0,
                        0,
                        0.35,
                      ),
                      offset: Offset(5, 5),
                      blurRadius: 52)
                ],
              ),
              child: Stack(
                children: [
                  Container(
                    width: 414 * horizontalScale,
                    height: 280 * verticalScale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image: AssetImage('assets/HomeImage.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 30 * verticalScale,
                      left: 10 * horizontalScale,
                      child: Container(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: Icon(
                                Icons.menu,
                                size: 30 * min(horizontalScale, verticalScale),
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10 * horizontalScale,
                            ),
                            Text(
                              'Home',
                              textScaleFactor:
                              min(horizontalScale, verticalScale),
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20 * horizontalScale,
                top: 20 * verticalScale,
              ),
              child: Text(
                'Feature Courses',
                textScaleFactor: min(horizontalScale, verticalScale),
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Poppins',
                  fontSize: 23,
                  letterSpacing:
                  0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: screenWidth,
              height: 430 * verticalScale,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                removeLeft: true,
                removeRight: true,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: course.length,
                  itemBuilder: (BuildContext context, index) {
                    if (course[index].FcSerialNumber != '') {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            courseId = course[index].courseDocumentId;
                          });

                          print(courseId);
                          if (course[index].isItComboCourse) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ComboStore(
                                  courses: course[index].courses,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const CatelogueScreen()),
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 15,
                          ),
                          child: Container(
                            width: 366 * horizontalScale,
                            height: 122 * verticalScale,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(31, 31, 31, 0.2),
                                    offset: Offset(0, 10),
                                    blurRadius: 20)
                              ],
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    course[index].courseImageUrl,
                                    fit: BoxFit.fill,
                                    height: 100 * verticalScale,
                                    width: 127 * horizontalScale,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10 * verticalScale,
                                    ),
                                    Container(
                                      width: 194,
                                      child: Text(
                                        course[index].courseName,
                                        textScaleFactor:
                                        min(horizontalScale, verticalScale),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20 * verticalScale,
                                    ),
                                    Image.asset(
                                      'assets/Rating.png',
                                      fit: BoxFit.fill,
                                      height: 11,
                                      width: 71,
                                    ),
                                    SizedBox(
                                      height: 20 * verticalScale,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'English  ||  ${course[index].numOfVideos} Videos',
                                          textAlign: TextAlign.left,
                                          textScaleFactor: min(
                                              horizontalScale, verticalScale),
                                          style: TextStyle(
                                              color:
                                              Color.fromRGBO(88, 88, 88, 1),
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          course[index].coursePrice,
                                          textScaleFactor: min(
                                              horizontalScale, verticalScale),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  155, 117, 237, 1),
                                              fontFamily: 'Poppins',
                                              fontSize: 18,
                                              letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.bold,
                                              height: 1),
                                        ),
                                      ],
                                    ),
                                  ],
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
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 10,
              ),
              child: Text(
                'Success Stories',
                textScaleFactor: min(horizontalScale, verticalScale),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Poppins',
                    fontSize: 23,
                    letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.w500,
                    height: 1),
              ),
            ),
            Container(
              height: screenHeight * 0.9 * verticalScale,
              width: screenWidth,
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
                              textScaleFactor: min(horizontalScale, verticalScale),
                            ));
                      } else {
                        final files = snapshot.data!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // buildHeader(files.length),
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
            Container(
              width: 414 * horizontalScale,
              height: 250 * verticalScale,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage('assets/a1.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Me',
                    textScaleFactor: min(horizontalScale, verticalScale),
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Poppins',
                        fontSize: 25,
                        letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.w500,
                        height: 1),
                  ),
                  Container(
                    width: 50 * horizontalScale,
                    child: Divider(
                        color: Color.fromRGBO(156, 91, 255, 1), thickness: 2),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Container(
                width: 364,
                height: 240,
                child: Text(
                  'I have 3\+ years experience in Machine Learning\. I have done 4 industrial IoT Machine Learning projects which includes data\-preprocessing\, data cleaning\, feature selection\, model building\, optimization and deployment to AWS Sagemaker\.  Now\, I even started my YouTube channel for sharing my ML and AWS knowledge Currently, I work with Tredence Inc. as a Data Scientist for the AI CoE (Center of Excellence) team. Here I work on challenging R&D projects and building various PoCs for winning new client projects for the company.When I had put papers in previous company, I practically had no offer. First 2 months were very difficult and disappointing as I couldn’t land any offer. But things suddenly started working out in the last month and I was able to bag 8 offers from various banks, analytical companies and some startups.I made this website to use all my interview experiences to help people land their dream job\.',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                bottom: 10,
              ),
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
                width: 300 * horizontalScale,
                height: 40 * verticalScale,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoreScreen()),
                        );
                      },
                      child: Text(
                        'My Recomemded Courses',
                        textScaleFactor: min(horizontalScale, verticalScale),
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
          ],
        ),
      ),
      // body: ListView(
      //   children: [
      //     Container(
      //       width: width,
      //       height: height * 2.82,
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(50),
      //           topRight: Radius.circular(50),
      //           // bottomLeft: Radius.circular(50),
      //           // bottomRight: Radius.circular(50),
      //         ),
      //         boxShadow: [
      //           BoxShadow(
      //               color: Color.fromRGBO(0, 0, 0, 0.3499999940395355),
      //               offset: Offset(5, 5),
      //               blurRadius: 52)
      //         ],
      //         color: Color.fromRGBO(249, 249, 249, 1),
      //       ),
      //       child: Stack(
      //         children: [
      //           Positioned(
      //               top: -1.9999924898147583,
      //               // left: 0,
      //               // right: 0,
      //               child: SingleChildScrollView(
      //                 child: Container(
      //                     width: 360.9999694824219,
      //                     height: 240.9999694824219,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.only(
      //                         topLeft: Radius.circular(0),
      //                         topRight: Radius.circular(0),
      //                         bottomLeft: Radius.circular(15),
      //                         bottomRight: Radius.circular(15),
      //                       ),
      //                       image: DecorationImage(
      //                         alignment: Alignment.center,
      //                         image: AssetImage('assets/ggf23.png'),
      //                         fit: BoxFit.fill
      //                       ),
      //                     )),
      //               )),
      //           Positioned(
      //               top: 274.0000305175781,
      //               left: 23.000001907348633,
      //               child: Text(
      //                 'Feature Courses',
      //                 textScaleFactor: min(horizontalScale, verticalScale),
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(
      //                     color: Color.fromRGBO(0, 0, 0, 1),
      //                     fontFamily: 'Poppins',
      //                     fontSize: 20,
      //                     letterSpacing:
      //                         0 /*percentages not used in flutter. defaulting to zero*/,
      //                     fontWeight: FontWeight.normal,
      //                     height: 1),
      //               )),
      //           Positioned(
      //             top: 312.0000610351562,
      //             left: 10.000001907348633,
      //             child: Ribbon(
      //               nearLength: 1,
      //               farLength: .5,
      //               title: '',
      //               titleStyle: TextStyle(
      //                   color: Colors.black,
      //                   // Colors.white,
      //                   fontSize: 18,
      //                   fontWeight: FontWeight.bold),
      //               color: Color.fromARGB(255, 11, 139, 244),
      //               location: RibbonLocation.topStart,
      //               child: Container(
      //                 width: width * .94,
      //                 height: height * .18,
      //                 decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(15),
      //                     color: Colors.white,
      //                     boxShadow: [
      //                       BoxShadow(
      //                         color: Colors.grey,
      //                         blurRadius: 8.0,
      //                         spreadRadius: .09,
      //                         offset: Offset(1, 5),
      //                       )
      //                     ]),
      //                 margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      //                 child: StreamBuilder<QuerySnapshot>(
      //                   stream: FirebaseFirestore.instance
      //                       .collection('courses')
      //                       .where('FC', isEqualTo: '1')
      //                       .snapshots(),
      //                   builder: (BuildContext context,
      //                       AsyncSnapshot<QuerySnapshot> snapshot) {
      //                     DocumentSnapshot document = snapshot.data!.docs[0];
      //                     Map<String, dynamic> map = snapshot.data!.docs[0]
      //                         .data() as Map<String, dynamic>;
      //                     if (!snapshot.hasData) return const SizedBox.shrink();
      //                     return InkWell(
      //                       onTap: () {
      //                         setState(() {
      //                           courseId = document.id;
      //                           print(document.id);
      //                           Navigator.push(
      //                             context,
      //                             MaterialPageRoute(
      //                                 builder: (context) =>
      //                                     const CatelogueScreen()),
      //                           );
      //                         });
      //                       },
      //                       child: Row(
      //                         children: [
      //                           Container(
      //                               width: width * .4,
      //                               height: height * .15,
      //                               margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
      //                               decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.all(
      //                                     Radius.circular(15.0)),
      //                                 color: Colors.white,
      //                               ),
      //                               child: img(width, height, map['image_url'])),
      //                           Column(
      //                               mainAxisAlignment: MainAxisAlignment.start,
      //                               crossAxisAlignment:
      //                                   CrossAxisAlignment.start,
      //                               children: [
      //                                 colname(
      //                                     map['name'], ''),
      //                                 SizedBox(
      //                                   height: 1,
      //                                 ),
      //                                 Star(),
      //                                 SizedBox(height: 10),
      //                                 Button1(width, map['Course Price']),
      //                               ])
      //                         ],
      //                       ),
      //                       // print(courseId);
      //                     );
      //                   },
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Positioned(
      //             top: 456.0000610351562,
      //             left: 10.000001907348633,
      //             child: Ribbon(
      //               nearLength: 68,
      //               farLength: 38,
      //               title: 'Sale',
      //               titleStyle: TextStyle(
      //                   color: Colors.black,
      //                   // Colors.white,
      //                   fontSize: 18,
      //                   fontWeight: FontWeight.bold),
      //               color: Color.fromARGB(255, 11, 139, 244),
      //               location: RibbonLocation.topStart,
      //               child: Container(
      //                 width: width * .94,
      //                 height: height * .18,
      //                 decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(15),
      //                     color: Colors.white,
      //                     boxShadow: [
      //                       BoxShadow(
      //                         color: Colors.grey,
      //                         blurRadius: 8.0,
      //                         spreadRadius: .09,
      //                         offset: Offset(1, 5),
      //                       )
      //                     ]),
      //                 margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      //                 child: StreamBuilder<QuerySnapshot>(
      //                   stream: FirebaseFirestore.instance
      //                       .collection('courses')
      //                       .where('FC', isEqualTo: '2')
      //                       .snapshots(),
      //                   builder: (BuildContext context,
      //                       AsyncSnapshot<QuerySnapshot> snapshot) {
      //                     DocumentSnapshot document = snapshot.data!.docs[0];
      //                     Map<String, dynamic> map = snapshot.data!.docs[0]
      //                         .data() as Map<String, dynamic>;
      //                     if (!snapshot.hasData) return const SizedBox.shrink();
      //                     return InkWell(
      //                       onTap: () {
      //                         setState(() {
      //                           courseId = document.id;
      //                           Navigator.push(
      //                             context,
      //                             MaterialPageRoute(
      //                                 builder: (context) =>
      //                                     const CatelogueScreen()),
      //                           );
      //                         });
      //                       },
      //                       child: Row(
      //                         children: [
      //                           Container(
      //                               width: width * .5,
      //                               height: height * .2,
      //                               margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
      //                               decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(35),
      //                                 color: Colors.white,
      //                               ),
      //                               child: img(width, height, map['image_url'])),
      //                           Column(
      //                               mainAxisAlignment: MainAxisAlignment.start,
      //                               crossAxisAlignment:
      //                                   CrossAxisAlignment.start,
      //                               children: [
      //                                 colname(map['name'], ''),
      //                                 SizedBox(
      //                                   height: 1,
      //                                 ),
      //                                 Star(),
      //                                 SizedBox(height: 10),
      //                                 Buttoncombo(width, '10,999', '3,999'),
      //                               ])
      //                         ],
      //                       ),
      //                       // print(courseId);
      //                     );
      //                   },
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Positioned(
      //             top: 602.0000610351562,
      //             left: 10.000001907348633,
      //             child: Ribbon(
      //               nearLength: 1,
      //               farLength: .5,
      //               title: '',
      //               titleStyle: TextStyle(
      //                   color: Colors.black,
      //                   // Colors.white,
      //                   fontSize: 18,
      //                   fontWeight: FontWeight.bold),
      //               color: Color.fromARGB(255, 11, 139, 244),
      //               location: RibbonLocation.topStart,
      //               child: Container(
      //                 width: width * .94,
      //                 height: height * .18,
      //                 decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(15),
      //                     color: Colors.white,
      //                     boxShadow: [
      //                       BoxShadow(
      //                         color: Colors.grey,
      //                         blurRadius: 8.0,
      //                         spreadRadius: .09,
      //                         offset: Offset(1, 5),
      //                       )
      //                     ]),
      //                 margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      //                 child: StreamBuilder<QuerySnapshot>(
      //                   stream: FirebaseFirestore.instance
      //                       .collection('courses')
      //                       .where('FC', isEqualTo: '3')
      //                       .snapshots(),
      //                   builder: (BuildContext context,
      //                       AsyncSnapshot<QuerySnapshot> snapshot) {
      //                     DocumentSnapshot document = snapshot.data!.docs[0];
      //                     Map<String, dynamic> map = snapshot.data!.docs[0]
      //                         .data() as Map<String, dynamic>;
      //                     if (!snapshot.hasData) return const SizedBox.shrink();
      //                     return InkWell(
      //                       onTap: () {
      //                         setState(() {
      //                           courseId = document.id;
      //                           Navigator.push(
      //                             context,
      //                             MaterialPageRoute(
      //                                 builder: (context) =>
      //                                     const CatelogueScreen()),
      //                           );
      //                         });
      //                       },
      //                       child: Row(
      //                         children: [
      //                           Container(
      //                               width: width * .4,
      //                               height: height * .15,
      //                               margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
      //                               decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(10),
      //                                 color: Colors.black,
      //                               ),
      //                               child: img(width, height, map['image_url'])),
      //                           Column(
      //                               mainAxisAlignment: MainAxisAlignment.start,
      //                               crossAxisAlignment:
      //                                   CrossAxisAlignment.start,
      //                               children: [
      //                                 colname(
      //                                     map['name'], ''),
      //                                 SizedBox(
      //                                   height: 1,
      //                                 ),
      //                                 Star(),
      //                                 SizedBox(height: 10),
      //                                 Button1(width, map['Course Price'])
      //                               ])
      //                         ],
      //                       ),
      //                       // print(courseId);
      //                     );
      //                   },
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Positioned(
      //               top: 765.0000305175781,
      //               left: 23.000001907348633,
      //               child: Text(
      //                 'Success Stories',
      //                 textScaleFactor: min(horizontalScale, verticalScale),
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(
      //                     color: Color.fromRGBO(0, 0, 0, 1),
      //                     fontFamily: 'Poppins',
      //                     fontSize: 20,
      //                     letterSpacing:
      //                         0 /*percentages not used in flutter. defaulting to zero*/,
      //                     fontWeight: FontWeight.normal,
      //                     height: 1),
      //               )),
      //           Positioned(
      //             top: 787.0000305175781,
      //             left: 5.000001907348633,
      //             child: Container(
      //               height: height * .9,
      //               width: width,
      //               padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      //               child: FutureBuilder<List<FirebaseFile>>(
      //                 future: futureFiles,
      //                 builder: (context, snapshot) {
      //                   switch (snapshot.connectionState) {
      //                     case ConnectionState.waiting:
      //                       return Center(child: CircularProgressIndicator());
      //                     default:
      //                       if (snapshot.hasError) {
      //                         return Center(
      //                             child: Text(
      //                           'Some error occurred!',
      //                           textScaleFactor:
      //                               min(horizontalScale, verticalScale),
      //                         ));
      //                       } else {
      //                         final files = snapshot.data!;

      //                         return Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             // buildHeader(files.length),
      //                             const SizedBox(height: 12),
      //                             Expanded(
      //                               child: GridView.builder(
      //                                 scrollDirection: Axis.vertical,
      //                                 physics: NeverScrollableScrollPhysics(),
      //                                 itemCount: files.length,
      //                                 itemBuilder: (context, index) {
      //                                   final file = files[index];

      //                                   return buildFile(context, file);
      //                                 },
      //                                 gridDelegate:
      //                                     SliverGridDelegateWithFixedCrossAxisCount(
      //                                         crossAxisCount: 2,
      //                                         crossAxisSpacing: 1,
      //                                         mainAxisSpacing: 4),
      //                               ),
      //                             ),
      //                           ],
      //                         );
      //                       }
      //                   }
      //                 },
      //               ),
      //             ),
      //           ),
      //           Positioned(
      //               top: 1365.0000305175781,
      //               left: 5.000001907348633,
      //               child: safearea1(context)),
      //           Positioned(
      //             top: 2085.0000305175781,
      //             left: 15.000001907348633,
      //             child: Container(
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(15),
      //                   color: Color.fromARGB(255, 6, 240, 185),
      //                   boxShadow: [
      //                     BoxShadow(
      //                       color: Colors.grey,
      //                       blurRadius: 8.0,
      //                       spreadRadius: .09,
      //                       offset: Offset(1, 5),
      //                     )
      //                   ]),
      //               width: width * .79,
      //               height: height * .045,
      //               child: Row(
      //                 children: [
      //                   FlatButton(
      //                     onPressed: () {
      //                       Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (context) =>  StoreScreen()),
      //                       );
      //                     },
      //                     child: Text(
      //                       'My Recomemded Courses',
      //                       textScaleFactor:
      //                           min(horizontalScale, verticalScale),
      //                       style: TextStyle(fontSize: 16),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     width: .01,
      //                   ),
      //                   Icon(
      //                     Icons.arrow_circle_right,
      //                     size: 30,
      //                     color: Colors.white,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           Positioned(
      //               top: 15.0000305175781,
      //               left: 5.000001907348633,
      //               child: Container(
      //                 child: Row(
      //                   children: [
      //                     IconButton(
      //                       onPressed: () {
      //                         Scaffold.of(context).openDrawer();
      //                       },
      //                       icon: Icon(
      //                         Icons.menu,
      //                         size: 40,
      //                         color: Colors.white,
      //                       ),
      //                     ),
      //                     SizedBox(
      //                       width: MediaQuery.of(context).size.width * 0.05,
      //                     ),
      //                     Text(
      //                       'Home',
      //                       textScaleFactor:
      //                           min(horizontalScale, verticalScale),
      //                       style: TextStyle(
      //                           fontSize: 35,
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.white),
      //                     )
      //                   ],
      //                 ),
      //               )),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}