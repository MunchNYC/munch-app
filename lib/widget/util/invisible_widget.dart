import 'package:flutter/material.dart';

class InvisibleWidget extends StatelessWidget {
  Widget child;

  InvisibleWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: child,
      visible: false,
      maintainSize: true,
      maintainState: true,
      maintainAnimation: true,
    );
  }
}
