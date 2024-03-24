import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableAddress extends StatelessWidget {
  final address;
  CopyableAddress(this.address, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
      style: TextStyle(
          fontSize: 16.0,
          color: Colors.indigo,
          backgroundColor: Colors.white70),
      text: address,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          Clipboard.setData(ClipboardData(text: address));
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Address copied to clipboard')));
        },
    ));
  }
}
