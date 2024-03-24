import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tezos_statz/ui/widgets/copyable_address.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          RichText(
            text:
                TextSpan(style: DefaultTextStyle.of(context).style, children: [
              TextSpan(
                  style: TextStyle(fontSize: 17.0),
                  text:
                      "This is a demo app that allows you to view Tezos account data. "),
              TextSpan(
                style: TextStyle(fontSize: 17.0),
                text: "It uses the Blockwatch ",
              ),
              TextSpan(
                style: TextStyle(fontSize: 17.0, color: Colors.blue),
                text: "TzPro API",
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.https("tzpro.io"));
                  },
              ),
              TextSpan(
                style: TextStyle(fontSize: 17.0),
                text: ". Not affiliated with Blockwatch. ",
              ),
              TextSpan(
                style: TextStyle(fontSize: 17.0),
                text: " Created with ",
              ),
              TextSpan(
                style: TextStyle(fontSize: 17.0, color: Colors.blue),
                text: "Flutter",
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.https("flutter.dev"));
                  },
              ),
            ]),
          ),
          Container(height: 17.0),
          GestureDetector(
            child: FlutterLogo(),
            onTap: () {
              launchUrl(Uri.https("flutter.dev"));
            },
          ),
          Container(height: 17.0),
          RichText(
            text:
                TextSpan(style: DefaultTextStyle.of(context).style, children: [
              TextSpan(
                style: TextStyle(fontSize: 17.0),
                text: "The code is open source and available on ",
              ),
              TextSpan(
                style: TextStyle(fontSize: 17.0, color: Colors.blue),
                text: "Github",
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.https("github.com", "/crcdng/tezos_statz"));
                  },
              ),
              TextSpan(
                style: TextStyle(fontSize: 17.0),
                text:
                    " under the Apache license. You can support development by donating to ",
              ),
            ]),
          ),
          Container(height: 17.0),
          CopyableAddress("tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk"),
          Container(height: 34.0),
          RichText(
            text:
                TextSpan(style: DefaultTextStyle.of(context).style, children: [
              TextSpan(
                style: TextStyle(fontSize: 17.0),
                text: "Made with 😍 by ",
              ),
              TextSpan(
                style: TextStyle(fontSize: 17.0, color: Colors.purple),
                text: "@crcdng",
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
