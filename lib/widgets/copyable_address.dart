import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableAddress extends StatelessWidget {
  final donationAddress;
  CopyableAddress(this.donationAddress, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
      style: TextStyle(
          fontSize: 16.0,
          color: Colors.indigo,
          backgroundColor: Colors.white70),
      text: donationAddress,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          Clipboard.setData(ClipboardData(text: donationAddress));
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Address copied to clipboard')));
        },
    ));
  }
}
