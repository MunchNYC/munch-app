import 'package:flutter/material.dart';
import 'package:munch/theme/text_style.dart';

class AccountTabMenuItem extends StatelessWidget {
  String text;
  Function onTap;
  Widget trailingIcon;

  AccountTabMenuItem({this.text, this.onTap, this.trailingIcon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w400)),
          trailingIcon
        ]
      )
    );
  }
}
