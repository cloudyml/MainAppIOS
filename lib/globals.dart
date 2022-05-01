import 'package:flutter/cupertino.dart';

TextEditingController email = TextEditingController();
TextEditingController otp = TextEditingController();
TextEditingController pass = TextEditingController();
TextEditingController mobile = TextEditingController();
TextEditingController username = TextEditingController();
bool isVerified = false;
bool submitting = false;

String? courseId;
String? moduleId;
String? topicId;

LinearGradient gradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF57ebde), Color(0xFFaefb2a)]);
