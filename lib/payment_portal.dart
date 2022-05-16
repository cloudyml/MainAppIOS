import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:upi_plugin/upi_plugin.dart';
import 'package:cloudyml_app2/coupon_code.dart';

class PaymentButton extends StatefulWidget {
  final ScrollController scrollController;
  final String couponCodeText;
  bool isPayButtonPressed;
  final Function changeState;
  final bool NoCouponApplied;
  final String buttonText;
  final String buttonTextForCode;
  final String amountString;
  final String courseName;
  final String courseDescription;
  // final Razorpay razorpay;
  final Function updateCourseIdToCouponDetails;
  final String? whichCouponCode;
  final String outStandingAmountString;
  bool isItComboCourse;

  String courseId;
  // String courseFetchedId;

  PaymentButton(
      {Key? key,
      required this.scrollController,
      required this.isPayButtonPressed,
      required this.changeState,
      required this.NoCouponApplied,
      required this.buttonText,
      required this.buttonTextForCode,
      required this.amountString,
      required this.courseName,
      required this.courseDescription,
      required this.updateCourseIdToCouponDetails,
      required this.outStandingAmountString,
      required this.courseId,
      required this.couponCodeText,
      required this.isItComboCourse,
      required this.whichCouponCode})
      : super(key: key);

  @override
  State<PaymentButton> createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> with CouponCodeMixin {
  bool isPayInPartsPressed = false;
  bool isMinAmountCheckerPressed = false;
  bool isOutStandingAmountCheckerPressed = false;
  bool whetherMinAmtBtnEnabled = true;
  bool whetherOutstandingAmtBtnEnabled = false;
  Map userData = Map<String, dynamic>();
  var _razorpay = Razorpay();

  Future<String> intiateUpiTransaction(String appName) async {
    String response = await UpiTransaction.initiateTransaction(
      app: appName,
      pa: 'cloudyml@icici',
      pn: 'CloudyML',
      mc: null,
      tr: null,
      tn: null,
      am: amountStringForUPI,
      cu: 'INR',
      url: 'https://www.cloudyml.com/',
      mode: null,
      orgid: null,
    );
    return response;
  }

  String? amountStringForRp;
  String? amountStringForUPI;

  void updateAmoutStringForUPI(bool isPayInPartsPressed,
      bool isMinAmountCheckerPressed, bool isOutStandingAmountCheckerPressed) {
    if (isPayInPartsPressed) {
      if (isMinAmountCheckerPressed) {
        setState(() {
          amountStringForUPI = '1000.00';
        });
      } else if (isOutStandingAmountCheckerPressed) {
        setState(() {
          amountStringForUPI = widget.outStandingAmountString;
        });
      }
    } else {
      amountStringForUPI =
          (double.parse(widget.amountString) / 100).toStringAsFixed(2);
    }
  }

  void updateAmoutStringForRP(bool isPayInPartsPressed,
      bool isMinAmountCheckerPressed, bool isOutStandingAmountCheckerPressed) {
    if (isPayInPartsPressed) {
      if (isMinAmountCheckerPressed) {
        setState(() {
          amountStringForRp = '100000';
        });
      } else if (isOutStandingAmountCheckerPressed) {
        setState(() {
          amountStringForRp =
              (double.parse(widget.outStandingAmountString) * 100)
                  .toStringAsFixed(2);
        });
      }
    } else {
      setState(() {
        amountStringForRp = widget.amountString;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getPayInPartsDetails();
    updateAmoutStringForUPI(isPayInPartsPressed, isMinAmountCheckerPressed,
        isOutStandingAmountCheckerPressed);
    updateAmoutStringForRP(isPayInPartsPressed, isMinAmountCheckerPressed,
        isOutStandingAmountCheckerPressed);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showToast("Payment failed");
    print("Payment Fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet");
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showToast("Payment successful");
    addCoursetoUser(widget.courseId);
    updateCouponDetailsToUser(
      couponCodeText: widget.couponCodeText,
      courseBaughtId: widget.courseId,
      NoCouponApplied: widget.NoCouponApplied,
    );
    updatePayInPartsDetails(
      isPayInPartsPressed,
      isMinAmountCheckerPressed,
      isOutStandingAmountCheckerPressed,
    );
    pushToHome();
    // disableMinAmtBtn();
    // enableoutStandingAmtBtn();
    print("Payment Done");
  }

  // void disableMinAmtBtn() {
  //   if (isMinAmountCheckerPressed) {
  //     setState(() {
  //       whetherMinAmtBtnEnabled = !whetherMinAmtBtnEnabled;
  //     });
  //   }
  // }

  // void enableoutStandingAmtBtn() {
  //   if (isOutStandingAmountCheckerPressed) {
  //     setState(() {
  //       whetherOutstandingAmtBtnEnabled = !whetherOutstandingAmtBtnEnabled;
  //     });
  //   }
  // }

  void getPayInPartsDetails() async {
    DocumentSnapshot userDs = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      userData = userDs.data() as Map<String, dynamic>;
    });
  }

  void pushToHome() {
    // Navigator.push(
    //   context,
    //   PageTransition(
    //     duration: Duration(milliseconds: 400),
    //     curve: Curves.bounceInOut,
    //     type: PageTransitionType.rightToLeft,
    //     child: HomePage(),
    //   ),
    // );
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          duration: Duration(milliseconds: 200),
          curve: Curves.bounceInOut,
          type: PageTransitionType.rightToLeft,
          child: HomePage(),
        ),
        (route) => false);
    print('pushedtohome');
  }

  bool stateOfMinAmtBtn() {
    bool? returnBool;
    if (userData['payInPartsDetails'][widget.courseId] == null) {
      if (userData['payInPartsDetails'][widget.courseId]['minAmtPaid']) {
        returnBool = false;
      }
      returnBool = true;
    }
    return returnBool!;
  }

  void updatePayInPartsDetails(
      bool isPayInPartsPressed,
      bool isMinAmountCheckerPressed,
      bool isOutStandingAmountCheckerPressed) async {
    if (isPayInPartsPressed) {
      Map map = Map<String, dynamic>();

      if (isMinAmountCheckerPressed) {
        map['minAmtPaid'] = true;
        map['outStandingAmtPaid'] = false;
        map['startDateOfLimitedAccess'] = DateTime.now().toString();
        map['endDateOfLimitedAccess'] =
            DateTime.now().add(Duration(days: 21)).toString();
        // map['endDateOfLimitedAccess'] =
        //     DateTime.now().add(Duration(seconds: 60)).toString();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'payInPartsDetails.${widget.courseId}': map});
      } else if (isOutStandingAmountCheckerPressed) {
        // DocumentSnapshot userDs = await FirebaseFirestore.instance
        //     .collection('Users')
        //     .doc(FirebaseAuth.instance.currentUser!.uid)
        //     .get();
        // Map userFields = userDs.data() as Map<String, dynamic>;
        // print(userFields['payInPartsDetails']['${widget.courseId}']
        //     ['minAmtPaid']);
        // final oldmap = Map<String, dynamic>();

        // oldmap['minAmtPaid'] = FieldValue.delete();
        // oldmap['startDateOfLimitedAccess'] = FieldValue.delete();
        // oldmap['endDateOfLimitedAccess'] = FieldValue.delete();
        // oldmap['outStandingAmtPaid'] = FieldValue.delete();

        map['minAmtPaid'] = true;
        map['startDateOfLimitedAccess'] = await userData['payInPartsDetails']
            ['${widget.courseId}']['startDateOfLimitedAccess'];
        map['endDateOfLimitedAccess'] = await userData['payInPartsDetails']
            ['${widget.courseId}']['endDateOfLimitedAccess'];
        map['outStandingAmtPaid'] = true;
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(
                {'payInPartsDetails.${widget.courseId}': FieldValue.delete()});
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'payInPartsDetails.${widget.courseId}': map});
      }
    }
  }

  void addCoursetoUser(String id) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'paidCourseNames': FieldValue.arrayUnion([id])
    });
  }

  // void initState() {
  //   super.initState();
  //   updateAmoutStringForRP(
  //       widget.isPayInPartsPressed,
  //       widget.isMinAmountCheckerPressed,
  //       widget.isOutStandingAmountCheckerPressed);
  //   updateAmoutStringForUPI(
  //       widget.isPayInPartsPressed,
  //       widget.isMinAmountCheckerPressed,
  //       widget.isOutStandingAmountCheckerPressed);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey.shade100,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                widget.isPayButtonPressed = !widget.isPayButtonPressed;
              });
              // widget.changeState;
              if (widget.isPayButtonPressed) {
                Future.delayed(Duration(milliseconds: 150), () {
                  widget.scrollController.animateTo(
                      widget.scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeIn);
                });
              } else {
                Future.delayed(Duration(milliseconds: 150), () {
                  widget.scrollController.animateTo(
                      widget.scrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                });
              }
            },
            child: Center(
              child: Container(
                height: 60.0,
                width: 350.0,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.NoCouponApplied
                            ? widget.buttonText
                            : widget.buttonTextForCode,
                        style: TextStyle(
                            fontFamily: 'Bold',
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          widget.isPayButtonPressed
              ? Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    (widget.isItComboCourse &&
                            (widget.whichCouponCode == 'parts2'))
                        ? Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 10, 245, 10),
                                  child: Text('Pay in parts'),
                                ),
                                Container(
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 1.1,
                                    ),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isPayInPartsPressed =
                                                !isPayInPartsPressed;
                                          });
                                          // widget.pressPayInPartsButton();
                                        },
                                        child: Container(
                                          height: 60,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                              width: 1.1,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: Icon(Icons.pie_chart,
                                                    size: 43),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Pay in parts',
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                    Text(
                                                      'Pay min ₹1000 to get limited access of 20 days after that pay the rest and enjoy lifetime access',
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          color: Colors
                                                              .grey.shade500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      isPayInPartsPressed
                                          ? Container(
                                              //this container will expand onTap
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 180,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey.shade200,
                                                        width: 1.1,
                                                      ),
                                                      color: userData['payInPartsDetails']
                                                                  [widget
                                                                      .courseId] !=
                                                              null
                                                          ? Colors.grey.shade100
                                                          : Colors.white,
                                                      // color:if(userData[
                                                      //                   'payInPartsDetails']
                                                      //               [widget.courseId]==null){
                                                      //                 Colors.white
                                                      //               }else if(userData[
                                                      //                   'payInPartsDetails']
                                                      //               [widget.courseId]['isMinAmtPaid']){
                                                      //                 Colors.grey.shade100
                                                      //               }
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          child: Text(
                                                              'Pay  ₹1000.0/-'),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (userData[
                                                                        'payInPartsDetails']
                                                                    [widget
                                                                        .courseId] !=
                                                                null) return;
                                                            setState(() {
                                                              isMinAmountCheckerPressed =
                                                                  !isMinAmountCheckerPressed;
                                                            });
                                                            updateAmoutStringForUPI(
                                                                isPayInPartsPressed,
                                                                isMinAmountCheckerPressed,
                                                                isOutStandingAmountCheckerPressed);
                                                            updateAmoutStringForRP(
                                                                isPayInPartsPressed,
                                                                isMinAmountCheckerPressed,
                                                                isOutStandingAmountCheckerPressed);
                                                            print(
                                                                isMinAmountCheckerPressed);
                                                            print(
                                                                "Print payinparts:${isPayInPartsPressed}");
                                                            print(
                                                                amountStringForUPI);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 20),
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 3,
                                                                ),
                                                                color: isMinAmountCheckerPressed
                                                                    ? Color(
                                                                        0xFFaefb2a)
                                                                    : Colors
                                                                        .grey
                                                                        .shade100,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 180,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey.shade200,
                                                        width: 1.1,
                                                      ),
                                                      color: !(userData[
                                                                      'payInPartsDetails']
                                                                  [widget
                                                                      .courseId] ==
                                                              null)
                                                          ? Colors.white
                                                          : Colors
                                                              .grey.shade100,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          child: Text(
                                                              'Pay ₹${widget.outStandingAmountString}/-'),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (userData[
                                                                        'payInPartsDetails']
                                                                    [widget
                                                                        .courseId] ==
                                                                null) return;
                                                            setState(() {
                                                              isOutStandingAmountCheckerPressed =
                                                                  !isOutStandingAmountCheckerPressed;
                                                            });
                                                            updateAmoutStringForUPI(
                                                                isPayInPartsPressed,
                                                                isMinAmountCheckerPressed,
                                                                isOutStandingAmountCheckerPressed);
                                                            updateAmoutStringForRP(
                                                                isPayInPartsPressed,
                                                                isMinAmountCheckerPressed,
                                                                isOutStandingAmountCheckerPressed);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 20),
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 3,
                                                                ),
                                                                color: isOutStandingAmountCheckerPressed
                                                                    ? Color(
                                                                        0xFFaefb2a)
                                                                    : Colors
                                                                        .grey
                                                                        .shade100,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 240, 10),
                      child: Text('Pay with UPI'),
                    ),
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1.1,
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              intiateUpiTransaction(UpiApps.GooglePay);
                            },
                            child: Container(
                              height: 60,
                              child: Row(
                                // mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      left: 20,
                                      right: 15,
                                    ),
                                    child: Image.asset(
                                      'assets/Google_Pay.png',
                                      width: 45,
                                      height: 45,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Text(
                                      'Google Pay',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 100,
                                      top: 10,
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          InkWell(
                            onTap: () {
                              intiateUpiTransaction(UpiApps.PhonePe);
                            },
                            child: Container(
                              height: 60,
                              child: Row(
                                // mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 10,
                                      left: 20,
                                      right: 15,
                                    ),
                                    child: Image.asset(
                                      'assets/phonepe.png',
                                      width: 45,
                                      height: 45,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    child: Text(
                                      'PhonePe',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 116,
                                      bottom: 10,
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 170, 10),
                      child: Text('Other payment methods'),
                    ),
                    InkWell(
                      onTap: () {
                        // setState(() {
                        //   widget.courseId = widget.courseFetchedId;
                        // });
                        updateAmoutStringForRP(
                            isPayInPartsPressed,
                            isMinAmountCheckerPressed,
                            isOutStandingAmountCheckerPressed);
                        widget.updateCourseIdToCouponDetails();
                        var options = {
                          'key': 'rzp_test_JeYtB3dCPKFsoP',
                          'amount':
                              amountStringForRp, //amount is paid in paises so pay in multiples of 100
                          'name': widget.courseName,
                          'description': widget.courseDescription,
                          'timeout': 300, //in seconds
                          'prefill': {
                            'contact': '8879369452', //original number and email
                            'email': 'test@razorpay.com'
                          }
                        };
                        _razorpay.open(options);
                      },
                      child: Container(
                        height: 60,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            'Razorpay',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
