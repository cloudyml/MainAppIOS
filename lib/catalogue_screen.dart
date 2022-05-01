import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/course.dart';
import 'package:cloudyml_app2/demo/demo_course.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CatelogueScreen extends StatefulWidget {
  const CatelogueScreen({Key? key}) : super(key: key);

  @override
  State<CatelogueScreen> createState() => _CatelogueScreenState();
}

class _CatelogueScreenState extends State<CatelogueScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var _razorpay = Razorpay();
  var amountcontroller = TextEditingController();
  String? id;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showToast("Payment successful");
    addCoursetoUser(id!);
    print("Payment Done");
  }

  void addCoursetoUser(String id) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'paidCourseNames': FieldValue.arrayUnion([id])
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showToast("Payment failed");
    print("Payment Fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet");
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
     late final size;
    double height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
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
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("courses").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> map =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  if (map["name"].toString() == "null") {
                    return Container();
                  }
                  if (document.id == courseId) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 00.0, right: 18, left: 18, bottom: 10),
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(28),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.12,
                                              child: Image.network(
                                                map['image_url'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.58,
                                                child: Text(
                                                  map['name'],
                                                  style: TextStyle(
                                                      fontFamily: 'Bold',
                                                      color: Colors.black,
                                                      fontSize: 24),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.58,
                                                child: Text(
                                                  map['description'],
                                                  style: TextStyle(
                                                      fontFamily: 'Regular',
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 65,
                                  ),
                                  Text(
                                    "PRICE DETAILS",
                                    style: TextStyle(
                                      fontFamily: 'Bold',
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 10, right: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Course Price",
                                          style: TextStyle(
                                            fontFamily: 'Medium',
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          map["Course Price"],
                                          style: TextStyle(
                                            fontFamily: 'Medium',
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 10, right: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Discount",
                                          style: TextStyle(
                                            fontFamily: 'Medium',
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          map["Discount"],
                                          style: TextStyle(
                                            fontFamily: 'Medium',
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 20,
                                    thickness: 1,
                                    indent: 0,
                                    endIndent: 0,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 10, right: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Amount Payable",
                                          style: TextStyle(
                                            fontFamily: 'Medium',
                                            fontSize: 15,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Colors.grey.shade300),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Text(
                                                map["Amount Payable"],
                                                style: TextStyle(
                                                  fontFamily: 'Medium',
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                  ),
                                  
                                  map['demo'] == true
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  curve: Curves.bounceInOut,
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: DemoCourse()),
                                            );
                                          },
                                          child: Container(          //try demo button
                                            height: height*.06,
                                            width: width*.85,
                                            color: Colors.transparent,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    gradient: gradient,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.0))),
                                                child: const Center(
                                                  child: Text(
                                                    "Try Demo",
                                                    style: TextStyle(
                                                        fontFamily: 'Bold',
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: (() {
                                      setState(() {
                                        id = map['id'];
                                      });
                                      var options = {
                                        'key': 'rzp_test_JeYtB3dCPKFsoP',
                                        'amount': (int.parse(
                                                    map['Amount_Payablepay']) *
                                                100)
                                            .toString(), //amount is paid in paises so pay in multiples of 100
                                        'name': map['name'],
                                        'description': map['description'],
                                        'timeout': 300, //in seconds
                                        'prefill': {
                                          'contact':
                                              '8888888888', //original number and email
                                          'email': 'test@razorpay.com'
                                        }
                                      };
                                      _razorpay.open(options);
                                    }),
                                    child: Center(
                                      child: Container(
                                        height: 50.0,
                                        width: 350.0,
                                        color: Colors.transparent,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                gradient: gradient,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0))),
                                            child: const Center(
                                              child: Text(
                                                "Buy Now for ₹1,249.00 /-",
                                                style: TextStyle(
                                                    fontFamily: 'Bold',
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: 200,
                                    child: Text(
                                      "* Amount payable is inclusive of taxes. TERMS & CONDITIONS APPLY",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
          ))
        ],
      ),
    );
  }
}
