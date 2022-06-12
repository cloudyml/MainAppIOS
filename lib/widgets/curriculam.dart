import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/widgets/demo_video.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:flutter/material.dart';

class Curriculam extends StatefulWidget {
  // final List videoTitles;
  // final List SectionsNames;
  // final List quizTitles;
  // final List assignmentTitles;
  // final List interviewQuestions;
  // final String id;
  final map;

  const Curriculam({
    Key? key,
    required this.map,
    // required this.videoTitles,
    // required this.SectionsNames,
    // required this.quizTitles,
    // required this.assignmentTitles,
    // required this.interviewQuestions,
    // required this.id,
  }) : super(key: key);

  @override
  State<Curriculam> createState() => _CurriculamState();
}

class _CurriculamState extends State<Curriculam> {
  bool showMore = false;
  // bool changeToggleIcon = false;
  // bool showSec1 = false;
  // bool showSec2 = false;
  // bool showSec3 = false;
  // bool showSec4 = false;
  // bool showFullCurriculum = false;
  String? modId;

  void getModuleId() async {
    var dt = await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        // .where('firstType', isEqualTo: 'video')
        .get()
        .then((value) {
      setState(() {
        modId = value.docs[0].id;
      });
    });
    print(dt);
  }

  @override
  void initState() {
    super.initState();
    getModuleId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Curriculum',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Medium',
                ),
              ),
            ),
            SizedBox(height: 10),
            // Text(
            //     '${widget.SectionsNames.length} sections-${widget.videoTitles.length} videos-${widget.assignmentTitles.length} assignments-${widget.quizTitles.length} quizzes'),
            Container(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.map['sectionsName'].length,
                itemBuilder: (context, index1) {
                  return Column(
                    children: [
                      SizedBox(height: 8),
                      Container(
                        // height: 30,
                        child: Row(
                          children: [
                            Text(
                              widget.map['sectionsName'][index1],
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Medium',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: showMore ? null : 200,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget
                                  .map[
                                      '${widget.map['sectionsName'][index1]}']
                                  .length,
                              itemBuilder: ((context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 22,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            flex: 1, //
                                            child: Text('${index + 1} : '),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Text(
                                              widget.map[
                                                      '${widget.map!['sectionsName'][index1]}']
                                                  [index],
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Medium',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () async {
                                                // print(modId);
                                                String? modId;
                                                var dt = await FirebaseFirestore
                                                    .instance
                                                    .collection('courses')
                                                    .doc(courseId)
                                                    .collection('Modules')
                                                    .where('firstType',
                                                        isEqualTo: 'video')
                                                    .get()
                                                    .then((value) {
                                                  modId = value.docs[0].id;
                                                });
                                                print(modId);
                                                Map<String, dynamic>?
                                                    topicDetails;
                                                await FirebaseFirestore.instance
                                                    .collection('courses')
                                                    .doc(courseId)
                                                    .collection('Modules')
                                                    .doc(modId)
                                                    .collection('Topics')
                                                    .where('sr',
                                                        isEqualTo: index + 1)
                                                    .get()
                                                    .then((value) {
                                                  // print(value.docs[0]);
                                                  topicDetails =
                                                      value.docs[0].data();
                                                  print(topicDetails!['url']);
                                                  // topicId = value.docs[0].id;
                                                });
                                                if (index < 3 && index1 == 0) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          VideoPlayerCustom(
                                                              url:
                                                                  topicDetails![
                                                                      'url']),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Icon(
                                                Icons.play_circle_fill_outlined,
                                                color: index <= 2 && index1 == 0
                                                    ? Color(0xFF7860DC)
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          widget
                                      .map![
                                          '${widget.map['sectionsName'][index1]}']
                                      .length >
                                  4
                              ? TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (index1 == index1) {
                                        showMore = !showMore;
                                      }
                                    });
                                  },
                                  child: showMore
                                      ? Text('Show less')
                                      : Text('Show more'),
                                )
                              : Container()
                        ],
                      )

                      // index == 0
                      //     ? Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Container(
                      //             height: showSec1 ? null : 200,
                      //             child: ListView.builder(
                      //               // physics: allowScrolling
                      //               //     ? NeverScrollableScrollPhysics()
                      //               //     : BouncingScrollPhysics(),
                      //               physics: NeverScrollableScrollPhysics(),
                      //               shrinkWrap: true,
                      //               itemCount: widget.videoTitles.length,
                      //               itemBuilder: (context, index) {
                      //                 return Container(
                      //                   decoration: BoxDecoration(
                      //                     borderRadius:
                      //                         BorderRadius.circular(0),
                      //                     color: Colors.white,
                      //                   ),
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.all(15.0),
                      //                     child: Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceBetween,
                      //                       children: [
                      //                         Text(
                      //                           '${index + 1}. ${widget.videoTitles[index]}',
                      //                           style: TextStyle(
                      //                             fontSize: 14,
                      //                             fontFamily: 'Medium',
                      //                           ),
                      //                         ),
                      //                         InkWell(
                      //                           onTap: () async {
                      //                             // print(modId);
                      //                             String? modId;
                      //                             var dt =
                      //                                 await FirebaseFirestore
                      //                                     .instance
                      //                                     .collection('courses')
                      //                                     .doc(courseId)
                      //                                     .collection('Modules')
                      //                                     .where('firstType',
                      //                                         isEqualTo:
                      //                                             'video')
                      //                                     .get()
                      //                                     .then((value) {
                      //                               modId = value.docs[0].id;
                      //                               // setState(() {
                      //                               //   // modId = value.docs[0].id;
                      //                               // });
                      //                             });
                      //                             print(modId);
                      //                             Map<String, dynamic>?
                      //                                 topicDetails;
                      //                             await FirebaseFirestore
                      //                                 .instance
                      //                                 .collection('courses')
                      //                                 .doc(courseId)
                      //                                 .collection('Modules')
                      //                                 .doc(modId)
                      //                                 .collection('Topics')
                      //                                 .where('sr',
                      //                                     isEqualTo: index + 1)
                      //                                 .get()
                      //                                 .then((value) {
                      //                               // print(value.docs[0]);
                      //                               topicDetails =
                      //                                   value.docs[0].data();
                      //                               print(topicDetails!['url']);
                      //                               // topicId = value.docs[0].id;
                      //                             });
                      //                             if (index < 3) {
                      //                               Navigator.push(
                      //                                 context,
                      //                                 MaterialPageRoute(
                      //                                   builder: (context) =>
                      //                                       VideoPlayerCustom(
                      //                                           url:
                      //                                               topicDetails![
                      //                                                   'url']),
                      //                                 ),
                      //                               );
                      //                             }
                      //                           },
                      //                           child: Icon(
                      //                             Icons
                      //                                 .play_circle_fill_outlined,
                      //                             color: index <= 2
                      //                                 ? Color(0xFF7860DC)
                      //                                 : null,
                      //                           ),
                      //                         )
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //           widget.videoTitles.length > 4
                      //               ? Padding(
                      //                   padding:
                      //                       const EdgeInsets.only(left: 10),
                      //                   child: TextButton(
                      //                     onPressed: () {
                      //                       setState(() {
                      //                         showSec1 = !showSec1;
                      //                       });
                      //                     },
                      //                     child: !showSec1
                      //                         ? Text('Show more')
                      //                         : Text('Show less'),
                      //                   ),
                      //                 )
                      //               : Container(),
                      //         ],
                      //       )
                      //     : Container(),
                      // index == 1
                      //     ? Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Container(
                      //             height: showSec2 ? null : 200,
                      //             child: ListView.builder(
                      //               physics: NeverScrollableScrollPhysics(),
                      //               shrinkWrap: true,
                      //               itemCount: widget.assignmentTitles.length,
                      //               itemBuilder: (context, index) {
                      //                 return Container(
                      //                   decoration: BoxDecoration(
                      //                     borderRadius:
                      //                         BorderRadius.circular(0),
                      //                     color: Colors.white,
                      //                   ),
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.all(15.0),
                      //                     child: Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceBetween,
                      //                       children: [
                      //                         Text(
                      //                           '${index + 1}. ${widget.assignmentTitles[index]}',
                      //                           style: TextStyle(
                      //                             fontSize: 14,
                      //                             fontFamily: 'Medium',
                      //                           ),
                      //                         ),
                      //                         Icon(
                      //                           Icons.assignment_rounded,
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //           widget.assignmentTitles.length > 4
                      //               ? Padding(
                      //                   padding:
                      //                       const EdgeInsets.only(left: 10),
                      //                   child: TextButton(
                      //                     onPressed: () {
                      //                       setState(() {
                      //                         showSec2 = !showSec2;
                      //                       });
                      //                     },
                      //                     child: !showSec2
                      //                         ? Text('Show more')
                      //                         : Text('Show less'),
                      //                   ),
                      //                 )
                      //               : Container(),
                      //         ],
                      //       )
                      //     : Container(),
                      // index == 2
                      //     ? Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Container(
                      //             height: showSec3 ? null : 200,
                      //             child: ListView.builder(
                      //               physics: NeverScrollableScrollPhysics(),
                      //               shrinkWrap: true,
                      //               itemCount: widget.quizTitles.length,
                      //               itemBuilder: (context, index) {
                      //                 return Container(
                      //                   decoration: BoxDecoration(
                      //                     borderRadius:
                      //                         BorderRadius.circular(0),
                      //                     color: Colors.white,
                      //                   ),
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.all(15.0),
                      //                     child: Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceBetween,
                      //                       children: [
                      //                         Text(
                      //                           '${index + 1}. ${widget.quizTitles[index]}',
                      //                           style: TextStyle(
                      //                             fontSize: 14,
                      //                             fontFamily: 'Medium',
                      //                           ),
                      //                         ),
                      //                         Icon(Icons.quiz),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //           widget.quizTitles.length > 4
                      //               ? Padding(
                      //                   padding:
                      //                       const EdgeInsets.only(left: 10),
                      //                   child: TextButton(
                      //                     onPressed: () {
                      //                       setState(() {
                      //                         showSec3 = !showSec3;
                      //                       });
                      //                     },
                      //                     child: !showSec3
                      //                         ? Text('Show more')
                      //                         : Text('Show less'),
                      //                   ),
                      //                 )
                      //               : Container(),
                      //         ],
                      //       )
                      //     : Container(),
                      // index == 3
                      //     ? Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Container(
                      //             height: showSec4 ? null : 200,
                      //             child: ListView.builder(
                      //               physics: NeverScrollableScrollPhysics(),
                      //               shrinkWrap: true,
                      //               itemCount: widget.interviewQuestions.length,
                      //               itemBuilder: (context, index) {
                      //                 return Container(
                      //                   decoration: BoxDecoration(
                      //                     borderRadius:
                      //                         BorderRadius.circular(0),
                      //                     color: Colors.white,
                      //                   ),
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.all(15.0),
                      //                     child: Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceBetween,
                      //                       children: [
                      //                         Text(
                      //                           '${index + 1}. ${widget.interviewQuestions[index]}',
                      //                           style: TextStyle(
                      //                             fontSize: 14,
                      //                             fontFamily: 'Medium',
                      //                           ),
                      //                         ),
                      //                         Icon(Icons.question_answer),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //           widget.interviewQuestions.length > 4
                      //               ? Padding(
                      //                   padding:
                      //                       const EdgeInsets.only(left: 10),
                      //                   child: TextButton(
                      //                     onPressed: () {
                      //                       setState(() {
                      //                         showSec3 = !showSec3;
                      //                       });
                      //                     },
                      //                     child: !showSec4
                      //                         ? Text('Show more')
                      //                         : Text('Show less'),
                      //                   ),
                      //                 )
                      //               : Container(),
                      //         ],
                      //       )
                      //     : Container(),
                      // TextButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       if (index == 0) {
                      //         showSec1 = !showSec1;
                      //         // changeToggleIcon=!changeToggleIcon;
                      //       } else if (index == 1) {
                      //         showSec2 = !showSec2;
                      //       } else if (index == 2) {
                      //         showSec3 = !showSec3;
                      //       } else if (index == 3) {
                      //         showSec4 = !showSec4;
                      //       }
                      //       // showSec$index+=!showSec${index+1};
                      //     });
                      //   },
                      //   child: showMore ? Text('Show less') : Text('Show more'),
                      // ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
