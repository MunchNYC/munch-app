import 'package:flutter/material.dart';
import 'package:munch/util/app.dart';

class AlertDialogBuilder{
  static String defaultDialogTitle = App.translate("alert_dialog.title.default");

  static final AlertDialogBuilder _singleton = AlertDialogBuilder._internal();

  factory AlertDialogBuilder() {
    return _singleton;
  }

  AlertDialogBuilder._internal();

  Widget _buildAlertDialog(BuildContext dialogContext, BuildContext initiatorContext, String dialogTitle, String dialogText, Function yesCallback){
    return AlertDialog(
      title: Text(dialogTitle ?? defaultDialogTitle),
      content: Text(dialogText),
      actions: [
        FlatButton(
          child: Text(App.translate("alert_dialog.negative_button.text.default")),
          onPressed: () {
            Navigator.of(dialogContext).pop(); // dismiss
          },
        ),
        FlatButton(
          child: Text(App.translate("alert_dialog.positive_button.text.default")),
          onPressed: () {
            Navigator.of(dialogContext).pop(); // dismiss
            yesCallback();
          },
        ),
      ],
    );

  }

  void showAlertDialogWidget(BuildContext initiatorContext, String dialogTitle, String dialogText, Function yesCallback){
    showDialog(
      context: initiatorContext,
      builder: (BuildContext context) {
        return _buildAlertDialog(context, initiatorContext, dialogTitle, dialogText, yesCallback);
      },
    );
  }


}