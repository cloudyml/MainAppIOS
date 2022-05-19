import 'package:cloudyml_app2/coupon_code.dart';
import 'package:cloudyml_app2/payment_portal.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? map;
  const PaymentScreen({Key? key, required this.map}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with CouponCodeMixin {
  var amountcontroller = TextEditingController();
  final TextEditingController couponCodeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // GlobalKey key = GlobalKey();
  // final scaffoldState = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> showBottomSheet = ValueNotifier(false);
  // VoidCallback? _showPersistentBottomSheetCallBack;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              child: Column(children: [
                Container(
                  child: Text(
                    "PRICE DETAILS",
                    style: TextStyle(
                      fontFamily: 'Bold',
                      fontSize: 18,
                    ),
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
                          NoCouponApplied = whetherCouponApplied(
                            couponCodeText: couponCodeController.text,
                          );
                          couponAppliedResponse = whenCouponApplied(
                            couponCodeText: couponCodeController.text,
                          );
                          finalamountToDisplay = amountToDisplayAfterCCA(
                            amountPayable: widget.map!['Amount Payable'],
                            couponCodeText: couponCodeController.text,
                          );
                          finalAmountToPay = amountToPayAfterCCA(
                            couponCodeText: couponCodeController.text,
                            amountPayable: widget.map!['Amount Payable'],
                          );
                          discountedPrice = discountAfterCCA(
                              couponCodeText: couponCodeController.text,
                              amountPayable: widget.map!['Amount Payable']);
                        });
                        print('Button working');
                      },
                    ),
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    suffixIconConstraints:
                        BoxConstraints(maxHeight: 50, minWidth: 100),
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
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Course Price",
                        style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.map!["Course Price"],
                        style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 10, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Discount",
                        style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        NoCouponApplied ? '₹${widget.map!["Discount"]} /-' : discountedPrice,
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
                  padding: const EdgeInsets.only(top: 5.0, bottom: 10, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.shade300),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              NoCouponApplied
                                  ? '₹${widget.map!["Amount Payable"]} /-'
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
                // map['demo'] == true
                //     ? InkWell(
                //         onTap: () {
                //           Navigator.push(
                //             context,
                //             PageTransition(
                //                 duration: Duration(
                //                     milliseconds: 400),
                //                 curve: Curves.bounceInOut,
                //                 type: PageTransitionType
                //                     .rightToLeft,
                //                 child: DemoCourse()),
                //           );
                //         },
                //         child: Container(
                //           //try demo button
                //           height: height * .06,
                //           width: width * .85,
                //           color: Colors.transparent,
                //           child: Container(
                //               decoration: BoxDecoration(
                //                   gradient: gradient,
                //                   borderRadius:
                //                       BorderRadius.all(
                //                           Radius.circular(
                //                               50.0))),
                //               child: const Center(
                //                 child: Text(
                //                   "Try Demo",
                //                   style: TextStyle(
                //                       fontFamily: 'Bold',
                //                       fontSize: 15,
                //                       fontWeight:
                //                           FontWeight.bold),
                //                   textAlign:
                //                       TextAlign.center,
                //                 ),
                //               )),
                //         ),
                //       )
                //     : Container(),
                SizedBox(
                  height: 20,
                ),
                PaymentButton(
                  amountString: (double.parse(NoCouponApplied
                              ? widget.map!['Amount_Payablepay']
                              : finalAmountToPay) *
                          100)
                      .toString(),
                  buttonText: "Buy Now for ${widget.map!['Course Price']}",
                  buttonTextForCode: "Buy Now for $finalamountToDisplay",
                  changeState: () {
                    setState(() {
                      isPayButtonPressed = !isPayButtonPressed;
                    });
                  },
                  courseDescription: widget.map!['description'],
                  courseName: widget.map!['name'],
                  isPayButtonPressed: isPayButtonPressed,
                  NoCouponApplied: NoCouponApplied,
                  // razorpay: _razorpay,
                  scrollController: _scrollController,
                  updateCourseIdToCouponDetails: () {
                    void addCourseId() {
                      setState(() {
                        id = widget.map!['id'];
                      });
                    }
              
                    addCourseId();
                    print(NoCouponApplied);
                  },
                  // isPayInPartsPressed: isPayInPartsPressed,
                  outStandingAmountString: (double.parse(NoCouponApplied
                              ? widget.map!['Amount_Payablepay']
                              : finalAmountToPay) -
                          1000)
                      .toStringAsFixed(2),
                  courseId: widget.map!['id'],
                  couponCodeText: couponCodeController.text,
                  isItComboCourse: false,
                  whichCouponCode: '',
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
        ),
      ),
    );
  }
}
