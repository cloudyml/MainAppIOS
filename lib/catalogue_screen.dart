import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/coupon_code.dart';
import 'package:cloudyml_app2/demo/demo_course.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/payment_portal.dart';
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
    with SingleTickerProviderStateMixin, CouponCodeMixin {
  TabController? _tabController;
  // var _razorpay = Razorpay();
  var amountcontroller = TextEditingController();
  final TextEditingController couponCodeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? id;

  String couponAppliedResponse = "";

  //If it is false amountpayble showed will be the amount fetched from db
  //If it is true which will be set to true if when right coupon code is
  //applied and the amountpayble will be set using appludiscount to the finalamountpayble variable
  // declared below same for discount
  bool NoCouponApplied = true;

  String finalamountToDisplay = "";

  String finalAmountToPay = "";

  String discountedPrice = "";

  bool isPayButtonPressed = false;

  bool isPayInPartsPressed = false;

  bool isMinAmountCheckerPressed = false;

  bool isOutStandingAmountCheckerPressed = false;

  // void whenCouponApplied() {
  //   if (couponCodeController.text.isNotEmpty) {
  //     if (couponCodeController.text.toLowerCase() == 'save10') {
  //       setState(() {
  //         couponAppliedResponse = 'Voucher is applied !';
  //         NoCouponApplied = false;
  //       });
  //     } else {
  //       setState(() {
  //         couponAppliedResponse = 'Code is invalid.';
  //       });
  //     }
  //   } else {
  //     setState(() {
  //       couponAppliedResponse = 'Enter the code to apply';
  //     });
  //   }
  // }

  // void applydiscount(String amountPayable, String discount) {
  //   if (couponCodeController.text.isNotEmpty) {
  //     if (couponCodeController.text.toLowerCase() == 'save10') {
  //       setState(() {
  //         finalAmountToPay =
  //             (double.parse(amountPayable) * 0.9).toStringAsFixed(2);
  //         finalamountToDisplay =
  //             '₹${(double.parse(amountPayable) * 0.9).toStringAsFixed(2)} /-';
  //         discountedPrice =
  //             '₹${(double.parse(amountPayable) * 0.1).toStringAsFixed(2)} /-';
  //       });
  //     }
  //   }
  // }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   showToast("Payment successful");
  //   addCoursetoUser(id!);
  //   updateCouponDetailsToUser(
  //     couponCodeText: couponCodeController.text,
  //     courseBaughtId: id!,
  //     NoCouponApplied: NoCouponApplied,
  //   );
  //   updatePayInPartsDetails(
  //     isPayInPartsPressed,
  //     isMinAmountCheckerPressed,
  //     isOutStandingAmountCheckerPressed,
  //   );
  //   pushToHome();
  //   print("Payment Done");
  // }

  // void pushToHome() {
  //   // Navigator.push(
  //   //   context,
  //   //   PageTransition(
  //   //     duration: Duration(milliseconds: 400),
  //   //     curve: Curves.bounceInOut,
  //   //     type: PageTransitionType.rightToLeft,
  //   //     child: HomePage(),
  //   //   ),
  //   // );
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       PageTransition(
  //         duration: Duration(milliseconds: 200),
  //         curve: Curves.bounceInOut,
  //         type: PageTransitionType.rightToLeft,
  //         child: HomePage(),
  //       ),
  //       (route) => false);
  //   print('pushedtohome');
  // }

  // void changeBoolforPIPB() {
  //   setState(() {
  //     isPayInPartsPressed = !isPayButtonPressed;
  //   });
  // }

  // void changeBoolforIMACP() {
  //   setState(() {
  //     isMinAmountCheckerPressed = !isMinAmountCheckerPressed;
  //   });
  // }

  // void changeBoolforIOACP() {
  //   setState(() {
  //     isOutStandingAmountCheckerPressed = !isOutStandingAmountCheckerPressed;
  //   });
  // }

  // void updatePayInPartsDetails(
  //     bool isPayInPartsPressed,
  //     bool isMinAmountCheckerPressed,
  //     bool isOutStandingAmountCheckerPressed) async {
  //   if (isPayInPartsPressed) {
  //     Map map = Map<String, dynamic>();

  //     if (isMinAmountCheckerPressed) {
  //       map['minAmtPaid'] = true;
  //       map['outStandingAmtPaid'] = false;
  //       map['startDateOfLimitedAccess'] = DateTime.now();
  //       map['endDateOfLimitedAccess'] = DateTime.now().add(Duration(days: 20));
  //     } else if (isOutStandingAmountCheckerPressed) {
  //       map['outStandingAmtPaid'] = true;
  //     }
  //     await FirebaseFirestore.instance
  //         .collection('Users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update({
  //       'payInPartsDetails': FieldValue.arrayUnion([
  //         {'$id': map}
  //       ])
  //     });
  //   }
  // }

  // void addCoursetoUser(String id) async {
  //   await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .update({
  //     'paidCourseNames': FieldValue.arrayUnion([id])
  //   });
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   showToast("Payment failed");
  //   print("Payment Fail");
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   print("External wallet");
  // }

  @override
  void initState() {
    super.initState();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    couponCodeController.dispose();
    _scrollController.dispose();
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
                controller: _scrollController,
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
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SingleChildScrollView(
                                  child: Column(
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
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Coupon code',
                                    style: TextStyle(fontFamily: 'Medium'),
                                  ),
                                ),
                                TextField(
                                  enabled: NoCouponApplied ? true : false,
                                  controller: couponCodeController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1.2,
                                    fontFamily: 'Medium',
                                  ),
                                  decoration: InputDecoration(
                                    suffixIcon: TextButton(
                                      child: Text(
                                        'Apply',
                                        style: TextStyle(
                                          color: Color(0xFFaefb2a),
                                          fontFamily: 'Medium',
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          NoCouponApplied =
                                              whetherCouponApplied(
                                            couponCodeText:
                                                couponCodeController.text,
                                          );
                                          couponAppliedResponse =
                                              whenCouponApplied(
                                            couponCodeText:
                                                couponCodeController.text,
                                          );
                                          finalamountToDisplay =
                                              amountToDisplayAfterCCA(
                                            amountPayable:
                                                map['Amount Payable'],
                                            couponCodeText:
                                                couponCodeController.text,
                                          );
                                          finalAmountToPay =
                                              amountToPayAfterCCA(
                                            couponCodeText:
                                                couponCodeController.text,
                                            amountPayable:
                                                map['Amount Payable'],
                                          );
                                          discountedPrice = discountAfterCCA(
                                              couponCodeText:
                                                  couponCodeController.text,
                                              amountPayable:
                                                  map['Amount Payable']);
                                        });
                                        print('Button working');
                                      },
                                    ),
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    suffixIconConstraints: BoxConstraints(
                                        maxHeight: 50, minWidth: 100),
                                    // contentPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    couponAppliedResponse,
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
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
                                        NoCouponApplied
                                            ? '₹${map["Discount"]} /-'
                                            : discountedPrice,
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
                                            padding: const EdgeInsets.all(14.0),
                                            child: Text(
                                              NoCouponApplied
                                                  ? '₹${map["Amount Payable"]} /-'
                                                  : finalamountToDisplay,
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
                                                duration:
                                                    Duration(milliseconds: 400),
                                                curve: Curves.bounceInOut,
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: DemoCourse()),
                                          );
                                        },
                                        child: Container(
                                          //try demo button
                                          height: height * .06,
                                          width: width * .85,
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
                                PaymentButton(
                                  amountString: (double.parse(NoCouponApplied
                                              ? map['Amount_Payablepay']
                                              : finalAmountToPay) *
                                          100)
                                      .toString(),
                                  buttonText:
                                      "Buy Now for ${map['Course Price']}",
                                  buttonTextForCode:
                                      "Buy Now for $finalamountToDisplay",
                                  changeState: () {
                                    setState(() {
                                      isPayButtonPressed = !isPayButtonPressed;
                                    });
                                  },
                                  courseDescription: map['description'],
                                  courseName: map['name'],
                                  isPayButtonPressed: isPayButtonPressed,
                                  NoCouponApplied: NoCouponApplied,
                                  // razorpay: _razorpay,
                                  scrollController: _scrollController,
                                  updateCourseIdToCouponDetails: () {
                                    void addCourseId() {
                                      setState(() {
                                        id = map['id'];
                                      });
                                    }

                                    addCourseId();
                                    print(NoCouponApplied);
                                  },
                                  // isPayInPartsPressed: isPayInPartsPressed,
                                  outStandingAmountString: (double.parse(
                                              NoCouponApplied
                                                  ? map['Amount_Payablepay']
                                                  : finalAmountToPay) -
                                          1000)
                                      .toStringAsFixed(2),
                                  // isMinAmountCheckerPressed:
                                  //     isMinAmountCheckerPressed,
                                  // isOutStandingAmountCheckerPressed:
                                  //     isOutStandingAmountCheckerPressed,
                                  courseId: map['id'],
                                  couponCodeText: couponCodeController.text,
                                  isItComboCourse: false, whichCouponCode: '',
                                ),
                                // Container(
                                //   width: 350,
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(50),
                                //     color: Colors.grey.shade100,
                                //   ),
                                //   child: Column(
                                //     children: [
                                //       InkWell(
                                //         onTap: () {
                                //           setState(() {
                                //             isPayButtonPressed =
                                //                 !isPayButtonPressed;
                                //           });
                                //           if (isPayButtonPressed) {
                                //             Future.delayed(
                                //                 Duration(milliseconds: 150),
                                //                 () {
                                //               _scrollController.animateTo(
                                //                   _scrollController
                                //                       .position.maxScrollExtent,
                                //                   duration: Duration(
                                //                       milliseconds: 800),
                                //                   curve: Curves.easeIn);
                                //             });
                                //           } else {
                                //             Future.delayed(
                                //                 Duration(milliseconds: 150),
                                //                 () {
                                //               _scrollController.animateTo(
                                //                   _scrollController
                                //                       .position.minScrollExtent,
                                //                   duration: Duration(
                                //                       milliseconds: 400),
                                //                   curve: Curves.easeIn);
                                //             });
                                //           }
                                //         },
                                //         child: Center(
                                //           child: Container(
                                //             height: 60.0,
                                //             width: 350.0,
                                //             color: Colors.transparent,
                                //             child: Container(
                                //               decoration: BoxDecoration(
                                //                   gradient: gradient,
                                //                   borderRadius:
                                //                       BorderRadius.all(
                                //                           Radius.circular(
                                //                               50.0))),
                                //               child: Center(
                                //                 child: Padding(
                                //                   padding:
                                //                       const EdgeInsets.all(8.0),
                                //                   child: Text(
                                //                     NoCouponApplied
                                //                         ? "Buy Now for ${map['Course Price']}"
                                //                         : "Buy Now for $finalamountToDisplay",
                                //                     style: TextStyle(
                                //                         fontFamily: 'Bold',
                                //                         fontSize: 15,
                                //                         fontWeight:
                                //                             FontWeight.bold),
                                //                     textAlign: TextAlign.center,
                                //                   ),
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //       isPayButtonPressed
                                //           ? Column(
                                //               children: [
                                //                 SizedBox(
                                //                   height: 15,
                                //                 ),
                                //                 Container(
                                //                   width: 300,
                                //                   decoration: BoxDecoration(
                                //                     borderRadius:
                                //                         BorderRadius.circular(
                                //                             15),
                                //                     color: Colors.white,
                                //                   ),
                                //                   child: Column(
                                //                     children: [
                                //                       Padding(
                                //                         padding:
                                //                             const EdgeInsets
                                //                                 .all(8.0),
                                //                         child: Align(
                                //                           alignment:
                                //                               Alignment.topLeft,
                                //                           child: Text('UPI'),
                                //                         ),
                                //                       ),
                                //                       Divider(),
                                //                       Card(
                                //                         color: Colors
                                //                             .grey.shade100,
                                //                         margin: EdgeInsets
                                //                             .symmetric(
                                //                                 horizontal:
                                //                                     35.0,
                                //                                 vertical: 3),
                                //                         shape:
                                //                             RoundedRectangleBorder(
                                //                           borderRadius:
                                //                               BorderRadius
                                //                                   .circular(7),
                                //                         ),
                                //                         child: Row(
                                //                           mainAxisAlignment:
                                //                               MainAxisAlignment
                                //                                   .center,
                                //                           children: [
                                //                             Container(
                                //                               width: 45,
                                //                               height: 45,
                                //                               child: Image.asset(
                                //                                   'assets/Google_Pay.png'),
                                //                             ),
                                //                             Padding(
                                //                               padding:
                                //                                   const EdgeInsets
                                //                                       .all(8.0),
                                //                               child: Text(
                                //                                 'Google Pay',
                                //                                 style:
                                //                                     TextStyle(
                                //                                   fontSize: 18,
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       ),
                                //                       Card(
                                //                         color: Colors
                                //                             .grey.shade100,
                                //                         margin: EdgeInsets
                                //                             .symmetric(
                                //                                 horizontal:
                                //                                     35.0,
                                //                                 vertical: 3),
                                //                         shape:
                                //                             RoundedRectangleBorder(
                                //                           borderRadius:
                                //                               BorderRadius
                                //                                   .circular(7),
                                //                         ),
                                //                         child: Row(
                                //                           mainAxisAlignment:
                                //                               MainAxisAlignment
                                //                                   .center,
                                //                           children: [
                                //                             Container(
                                //                               width: 45,
                                //                               height: 45,
                                //                               child: Image.asset(
                                //                                   'assets/phonepe.png'),
                                //                             ),
                                //                             Padding(
                                //                               padding:
                                //                                   const EdgeInsets
                                //                                       .all(8.0),
                                //                               child: Text(
                                //                                 'PhonePe',
                                //                                 style: TextStyle(
                                //                                     fontSize:
                                //                                         18),
                                //                               ),
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       ),
                                //                       SizedBox(
                                //                         height: 10,
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //                 SizedBox(
                                //                   width: 300,
                                //                   child: Row(
                                //                     children: [
                                //                       Expanded(
                                //                         child: Container(
                                //                           height: 1,
                                //                           width: 150,
                                //                           color: Colors
                                //                               .grey.shade300,
                                //                         ),
                                //                       ),
                                //                       Padding(
                                //                         padding:
                                //                             const EdgeInsets
                                //                                     .symmetric(
                                //                                 horizontal: 5,
                                //                                 vertical: 0),
                                //                         child: Text(
                                //                           'Or continue with',
                                //                           style: TextStyle(
                                //                               fontSize: 13),
                                //                         ),
                                //                       ),
                                //                       Expanded(
                                //                         child: Container(
                                //                           height: 1,
                                //                           width: 150,
                                //                           color: Colors
                                //                               .grey.shade300,
                                //                         ),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //                 InkWell(
                                //                   onTap: (() {
                                //                     setState(() {
                                //                       id = map['id'];
                                //                     });
                                //                     var options = {
                                //                       'key':
                                //                           'rzp_test_JeYtB3dCPKFsoP',
                                //                       'amount': (double.parse(
                                //                                   NoCouponApplied
                                //                                       ? map[
                                //                                           'Amount_Payablepay']
                                //                                       : finalAmountToPay) *
                                //                               100)
                                //                           .toString(), //amount is paid in paises so pay in multiples of 100
                                //                       'name': map['name'],
                                //                       'description':
                                //                           map['description'],
                                //                       'timeout':
                                //                           300, //in seconds
                                //                       'prefill': {
                                //                         'contact':
                                //                             '8879369452', //original number and email
                                //                         'email':
                                //                             'test@razorpay.com'
                                //                       }
                                //                     };
                                //                     _razorpay.open(options);
                                //                   }),
                                //                   child: Container(
                                //                     key: itemKey,
                                //                     height: 50,
                                //                     width: 300,
                                //                     decoration: BoxDecoration(
                                //                       borderRadius:
                                //                           BorderRadius.circular(
                                //                               15),
                                //                       color: Colors.white,
                                //                     ),
                                //                     child: Center(
                                //                       child: Text(
                                //                         'Razorpay',
                                //                         style: TextStyle(
                                //                             fontSize: 18),
                                //                       ),
                                //                     ),
                                //                   ),
                                //                 ),
                                //                 SizedBox(
                                //                   height: 10,
                                //                 ),
                                //               ],
                                //             )
                                //           : Container(),
                                //     ],
                                //   ),
                                // ),
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
