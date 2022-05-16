import 'package:flutter/material.dart';

class Curriculam extends StatefulWidget {
  final List videoTitles;
  final List SectionsNames;
  final List quizTitles;
  final List assignmentTitles;
  final List interviewQuestions;

  const Curriculam({
    Key? key,
    required this.videoTitles,
    required this.SectionsNames,
    required this.quizTitles,
    required this.assignmentTitles,
    required this.interviewQuestions,
  }) : super(key: key);

  @override
  State<Curriculam> createState() => _CurriculamState();
}

class _CurriculamState extends State<Curriculam> {
  bool showSec1 = false;
  bool showSec2 = false;
  bool showSec3 = false;
  bool showSec4 = false;
  bool showCurriculum = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
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
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.SectionsNames.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.SectionsNames[index],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Medium',
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (index == 0) {
                                      showSec1 = !showSec1;
                                    } else if (index == 1) {
                                      showSec2 = !showSec2;
                                    } else if (index == 2) {
                                      showSec3 = !showSec3;
                                    } else if (index == 3) {
                                      showSec4 = !showSec4;
                                    }
                                    // showSec$index+=!showSec${index+1};
                                  });
                                },
                                child: Icon(Icons.add),
                              )
                            ],
                          ),
                        ),
                      ),
                      showSec1
                          ? index == 0
                              ? Container(
                                  height: 200,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.videoTitles.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${index + 1}. ${widget.videoTitles[index]}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Medium',
                                                ),
                                              ),
                                              Icon(Icons.ondemand_video)
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container()
                          : Container(),
                      showSec2
                          ? index == 1
                              ? Container(
                                  height: 200,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.assignmentTitles.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${index + 1}. ${widget.assignmentTitles[index]}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Medium',
                                                ),
                                              ),
                                              Icon(Icons.assignment_rounded)
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container()
                          : Container(),
                      showSec3
                          ? index == 2
                              ? Container(
                                  height: 200,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.quizTitles.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${index + 1}. ${widget.quizTitles[index]}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Medium',
                                                ),
                                              ),
                                              Icon(Icons.quiz),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container()
                          : Container(),
                      showSec4
                          ? index == 3
                              ? Container(
                                  // height: 200,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.interviewQuestions.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${index + 1}. ${widget.interviewQuestions[index]}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Medium',
                                                ),
                                              ),
                                              Icon(Icons.question_answer),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container()
                          : Container(),
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
