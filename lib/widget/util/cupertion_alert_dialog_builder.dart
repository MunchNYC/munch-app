import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';

class CupertinoAlertDialogBuilder {
  static final CupertinoAlertDialogBuilder _singleton =
      CupertinoAlertDialogBuilder._internal();

  factory CupertinoAlertDialogBuilder() {
    return _singleton;
  }

  CupertinoAlertDialogBuilder._internal();

  Widget _buildAlertDialog(
      BuildContext dialogContext,
      String dialogTitle,
      String dialogDescription,
      String confirmText,
      String cancelText,
      Function confirmCallback,
      Function cancelCallback) {
    return CupertinoAlertDialog(
      title: Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: Text(dialogTitle,
              style: AppTextStyle.style(AppTextStylePattern.body3,
                  fontSizeOffset: 1.0, fontWeight: FontWeight.w600))),
      content: Text(dialogDescription,
          style: AppTextStyle.style(AppTextStylePattern.body2,
              fontSizeOffset: 1.0)),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(confirmText,
              style: AppTextStyle.style(AppTextStylePattern.heading6,
                  fontWeight: FontWeight.w400, color: Palette.hyperlink)),
          onPressed: confirmCallback,
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          isDestructiveAction: true,
          child: Text(cancelText,
              style: AppTextStyle.style(AppTextStylePattern.heading6,
                  fontWeight: FontWeight.w500, color: Palette.error)),
          onPressed: cancelCallback,
        )
      ],
    );
  }

  void showAlertDialogWidget(BuildContext initiatorContext,
      {String dialogTitle,
      String dialogDescription,
      String confirmText,
      String cancelText,
      Function confirmCallback,
      Function cancelCallback}) {
    showDialog(
      context: initiatorContext,
      builder: (BuildContext context) {
        return _buildAlertDialog(context, dialogTitle, dialogDescription,
            confirmText, cancelText, confirmCallback, cancelCallback);
      },
    );
  }
}
