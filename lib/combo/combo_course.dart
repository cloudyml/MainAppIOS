import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/course.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:flutter/material.dart';

class ComboCourse extends StatefulWidget {
  final List<dynamic>? courses;
  const ComboCourse({Key? key, this.courses}) : super(key: key);

  @override
  State<ComboCourse> createState() => _ComboCourseState();
}

class _ComboCourseState extends State<ComboCourse> {
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
          Expanded(
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
                    if (widget.courses!.contains(map['id'])) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              courseId = document.id;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Couse()),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: Colors.grey.shade200,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width:
                                          MediaQuery.of(context).size.height *
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
                                                  fontWeight: FontWeight.w500),
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
                                                        fontFamily: 'Medium',
                                                        color: Colors.black
                                                            .withOpacity(0.4),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
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
                                                          BorderRadius.circular(
                                                              20),
                                                      color:
                                                          Colors.grey.shade300),
                                                  child: Center(
                                                    child: Text(
                                                      '${map['videosCount']} videos',
                                                      style: TextStyle(
                                                          fontFamily: 'Medium',
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 48,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    gradient: gradient),
                                                child: Center(
                                                  child: Text(
                                                    map['Amount Payable'],
                                                    style: TextStyle(
                                                        fontFamily: 'Bold',
                                                        color: Colors.black,
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
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontFamily: 'Bold',
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontSize: 15),
                                              )
                                            ],
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
          ),
        ],
      ),
    );
  }
}
