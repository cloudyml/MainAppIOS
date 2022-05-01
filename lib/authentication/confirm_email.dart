import 'package:flutter/material.dart';

class ConfirmEmail extends StatefulWidget {
  @override
  _ConfirmEmailState createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text(
        'An email has just been sent to you, Click the link provided to complete registration',
        style: TextStyle(color: Colors.white, fontSize: 16),
      )),
    );
  }
}
