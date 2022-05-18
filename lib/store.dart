import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  Widget build(BuildContext context) {
    late final size;
    double height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 5,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('courses').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> map = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
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
                                      const CatelogueScreen()),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              // height: MediaQuery.of(context).size.height * 0.16,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade200,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.10,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.10,
                                        child: Image.network(
                                          map['image_url'].toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
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
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    'COMBO',
                                                    style: TextStyle(
                                                        fontFamily: 'SemiBold',
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
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                        // SizedBox(
                                        //   height: 10,
                                        // ),
                                        // Container(
                                        //   width: MediaQuery.of(context)
                                        //           .size
                                        //           .width *
                                        //       0.45,
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment
                                        //             .spaceBetween,
                                        //     children: [
                                        //       Container(
                                        //         child: Text(
                                        //           map["language"],
                                        //           style: TextStyle(
                                        //               fontFamily: 'Medium',
                                        //               color: Colors.black
                                        //                   .withOpacity(0.4),
                                        //               fontSize: 10,
                                        //               fontWeight:
                                        //                   FontWeight.w500),
                                        //         ),
                                        //       ),
                                        //       SizedBox(
                                        //         width: 6,
                                        //       ),
                                        //       Container(
                                        //         height: 30,
                                        //         width: width * .25,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     20),
                                        //             color:
                                        //                 Colors.grey.shade300),
                                        //         child: Center(
                                        //           child: Text(
                                        //             '${map['videosCount']} videos',
                                        //             style: TextStyle(
                                        //                 fontFamily: 'Medium',
                                        //                 color: Colors.black
                                        //                     .withOpacity(0.7),
                                        //                 fontSize: 10),
                                        //           ),
                                        //         ),
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),
                                        // SizedBox(
                                        //   height: 12,
                                        // ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Instructor : ${map['created by']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Medium',
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        // Text(
                                        //     'Mentors: ${map['mentors']}'),
                                        // SizedBox(
                                        //   height: 5,
                                        // ),
                                        !map['combo']
                                            ? Text(
                                                '${map['curriculum']['videoTitle'].length} Lectures-${map['curriculum']['assignmentTitle'].length} assignments-${map['curriculum']['quizTitle'].length} quizzes')
                                            : Text(
                                                '${map['courses'].length} courses'),
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
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
