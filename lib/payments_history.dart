import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title:Text('Payment History'),
      elevation: 0,
      centerTitle: true,),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('courses').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> map =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  if (map["name"].toString() == "null") {
                    return Container();
                  }
                  if (courses.contains(map['id'])) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey.shade100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        // width: 400,
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        map['name'],
                                        style: const TextStyle(
                                            fontFamily: 'Bold',
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                        width: 1.1,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Amount : ${map['Course Price']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Status :',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                userMap['payInPartsDetails']
                                                                [map['id']] !=
                                                            null &&
                                                        !userMap['payInPartsDetails']
                                                                [map['id']][
                                                            'outStandingAmtPaid']
                                                    ? Text(
                                                        'Pending',
                                                        style: const TextStyle(
                                                            fontFamily: 'Bold',
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors
                                                                .deepOrangeAccent),
                                                      )
                                                    : Text(
                                                        'Paid',
                                                        style: const TextStyle(
                                                            fontFamily: 'Bold',
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xFFaefb2a)),
                                                      ),
                                              ],
                                            )),
                                        userMap['couponCodeDetails']
                                                    [map['id']] ==
                                                null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Offer  : None',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Offer : ${userMap['couponCodeDetails'][map['id']]['couponCodeApplied']}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }),
      ),
    );
  }
}