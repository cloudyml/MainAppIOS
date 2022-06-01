import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple,
        child: Stack(
            children: [
          Positioned(
            // left: -50,
            // width: 100,
            // height: 100,
            top: -98.00000762939453,
            left: -88.00000762939453,
            // child: CircleAvatar(
            //   radius: 70,
            //   backgroundColor: Color.fromARGB(255, 173, 149, 149),
            // ),
            child: Container(
                width: 161.99998474121094,
                height: 161.99998474121094,
                decoration: BoxDecoration(
                  color: Color.fromARGB(55, 126, 106, 228),
                  borderRadius: BorderRadius.all(Radius.elliptical(
                      161.99998474121094, 161.99998474121094)),
                )),
          ),
          Positioned(
            // right: MediaQuery.of(context).size.width * (-.16),
            // bottom: MediaQuery.of(context).size.height * .7,
            top: 73.00000762939453,
            left: 309,

            // child: CircleAvatar(
            //   radius: 80,
            //   backgroundColor: Color.fromARGB(255, 173, 149, 149),
            // ),
            child: Container(
                width: 161.99998474121094,
                height: 161.99998474121094,
                decoration: BoxDecoration(
                  color: Color.fromARGB(55, 126, 106, 228),
                  borderRadius: BorderRadius.all(Radius.elliptical(
                      161.99998474121094, 161.99998474121094)),
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //color: Color.fromARGB(214, 83, 109, 254),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.17,
                      ),
                      Text(
                        'Store',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.06,
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        color: Colors.white),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("courses")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return const SizedBox.shrink();
                          return MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: MediaQuery.of(context).size.width * .5,
                                    childAspectRatio: .68),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document =
                                  snapshot.data!.docs[index];
                                  Map<String, dynamic> map =
                                  snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        courseId = document.id;
                                      });

                                      print(courseId);
                                      if (map['combo']) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ComboStore(
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
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(25),
                                          color: Color.fromARGB(
                                              192, 255, 255, 255),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    168,
                                                    133,
                                                    250,
                                                    0.7099999785423279),
                                                offset: Offset(2, 2),
                                                blurRadius: 5)
                                          ]),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(08.0),
                                        child: Column(
                                          //mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  top: 5),
                                              child: Container(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(15),
                                                  child: Image.network(
                                                    map['image_url']
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                    height: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .height *
                                                        .15,
                                                    width: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .width *
                                                        .4,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height:
                                              MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  .05,
                                              child: Text(
                                                map['name'],
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .width *
                                                        .043),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                              MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  .005,
                                            ),
                                            Row(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment
                                              //         .center,
                                              children: [
                                                Text(
                                                  map['language'],
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          .035),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(
                                                      context)
                                                      .size
                                                      .width *
                                                      .02,
                                                ),
                                                Text(
                                                  '||',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          .035),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(
                                                      context)
                                                      .size
                                                      .width *
                                                      .02,
                                                ),
                                                Text(
                                                  map['videosCount']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          .04),
                                                ),
                                                // const SizedBox(
                                                //   height: 10,
                                                // ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                              MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  .015,
                                            ),
                                            // Row(
                                            //   children: [
                                            //     Container(
                                            //       width:
                                            //           MediaQuery.of(context)
                                            //                   .size
                                            //                   .width *
                                            //               0.20,
                                            //       height:
                                            //           MediaQuery.of(context)
                                            //                   .size
                                            //                   .height *
                                            //               0.030,
                                            //       decoration: BoxDecoration(
                                            //           borderRadius:
                                            //               BorderRadius
                                            //                   .circular(10),
                                            //           color: Colors.green),
                                            //       child: const Center(
                                            //         child: Text(
                                            //           'ENROLL NOW',
                                            //           style: TextStyle(
                                            //               fontSize: 10,
                                            //               color:
                                            //                   Colors.white),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     const SizedBox(
                                            //       width: 15,
                                            //     ),
                                            //     Text(
                                            //       map['Course Price'],
                                            //       style: const TextStyle(
                                            //         fontSize: 13,
                                            //         color: Colors.indigo,
                                            //         fontWeight:
                                            //             FontWeight.bold,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            Row(

                                              children: [
                                                // SizedBox(
                                                //     width: MediaQuery.of(
                                                //         context)
                                                //         .size
                                                //         .width *
                                                //         .23),
                                                Text(
                                                  map['Course Price'],
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .width *
                                                        .04,
                                                    color: Colors.indigo,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }),
                  ),
                ),

              ],
            ),
          ),
        ]),
      ),
    );
  }
}