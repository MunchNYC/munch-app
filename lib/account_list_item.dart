import 'account_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountListItem extends StatelessWidget {
  final IconData icon;
  final text;
  final bool hasNavigation;
  final VoidCallback target;

  const AccountListItem(
      {Key key, this.hasNavigation, this.icon, this.text, this.target})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: target,
      child: Container(
        height: spacingUnit.w * 5.5,
        margin: EdgeInsets.symmetric(horizontal: spacingUnit.w * 4)
            .copyWith(bottom: spacingUnit.w * 2),
        padding: EdgeInsets.symmetric(horizontal: spacingUnit.w * 2),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: Offset(2, 2)),
            ],
            borderRadius: BorderRadius.circular(spacingUnit.w * 3),
            color: Colors.white),
        child: Row(
          children: <Widget>[
            Icon(
              this.icon,
              size: spacingUnit.w * 3,
            ),
            SizedBox(width: spacingUnit.w * 2.5),
            Text(
              this.text,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)
                  .copyWith(),
            ),
            Spacer(),
            if (this.hasNavigation)
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: spacingUnit.w * 2.5,
              ),
          ],
        ),
      ),
    );
  }
}
