import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPrivacy extends StatelessWidget {
  Future<void> _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RichText(
                  text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          'Munch protects your privacy and personal information.',
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                  TextSpan(
                      text: ' Learn More',
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchURL();
                        }),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
