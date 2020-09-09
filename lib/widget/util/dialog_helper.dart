import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';

// Need template T, because in the root of dialog body we have to put bloc, because Dialog has different context
class DialogHelper{
  String dialogTitle;
  Widget dialogContent;

  Color dialogTitleColor;

  DialogHelper({this.dialogTitle, this.dialogContent, this.dialogTitleColor = Palette.primary});

  void show(BuildContext context){
    showDialog(
        context: context,
        useRootNavigator: true,
        builder: (BuildContext ctx) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(dialogTitle != null) Text(dialogTitle, style: AppTextStyle.style(AppTextStylePattern.heading3, color: dialogTitleColor)),
                        if(dialogTitle != null) Divider(thickness: 1, color: Palette.secondaryDark),
                        if(dialogTitle != null) SizedBox(height: 5.0),
                        dialogContent
                      ]
                  )
              )
          );
        }
    );
  }
}