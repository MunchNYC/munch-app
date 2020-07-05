import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:munch/login_widget.dart';
import 'package:munch/service/google_authentication.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _googleAuthentication =
      GoogleAuthentication(FirebaseAuth.instance, GoogleSignIn());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Munch App',
      home: Login(_googleAuthentication),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Munch App'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
