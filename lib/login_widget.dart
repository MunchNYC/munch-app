import 'package:flutter/material.dart';
import 'package:munch/service/base_authentication.dart';
import 'home_widget.dart';

class Login extends StatefulWidget {
  final BaseAuthentication _authentication;

  Login(this._authentication);

  @override
  _LoginState createState() => _LoginState(_authentication);
}

class _LoginState extends State<Login> {
  final BaseAuthentication _authentication;
  bool _isLoading = false;

  _LoginState(this._authentication);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              _signInButton(),
              _progressIndicator()
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: _onSignInButtonTapped,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onSignInButtonTapped() {
    setState(() {
      _isLoading = true;
    });

    try {
      _authentication.signIn().whenComplete(() {
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Home();
            },
          ),
        );
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
      // TODO How do we want to display errors? https://munch.atlassian.net/browse/MUN-18
    }
  }

  Widget _progressIndicator() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
