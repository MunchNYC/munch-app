import 'package:flutter/material.dart';
import 'package:munch/util/app.dart';

// DON'T EVER PUT BlocProvider in Context tree of widget which will be disposed (like dialog), because Flutter will disable bloc provided into this BlocProvider
// Always parametrize dialogContent with required bloc outside of this widget
class DialogHelper {
  Widget dialogContent;
  bool isModal;
  bool rootNavigator;
  EdgeInsets padding;

  DialogHelper({
    this.dialogContent,
    this.isModal = false,
    this.rootNavigator = false,
    this.padding = const EdgeInsets.all(24.0)
  });

  void show(BuildContext context) {
    showDialog(
        context: context,
        useRootNavigator: rootNavigator,
        barrierDismissible: !isModal,
        builder: (BuildContext ctx) {
          return WillPopScope(
              onWillPop: () async {
                return !isModal;
              },
              child: Dialog(
                  insetPadding: EdgeInsets.only(left: padding.left, right: padding.right),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: SizedBox(
                      width: App.REF_DEVICE_WIDTH,
                      child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: padding.top, bottom: padding.bottom),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                                    child: dialogContent)
                              ])))));
        });
  }
}
