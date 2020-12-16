import 'package:flutter/material.dart';
import 'package:munch/util/app.dart';

// DON'T EVER PUT BlocProvider in Context tree of widget which will be disposes (like dialog), because Flutter will disable bloc provided into this BlocProvider
// Always parametrize dialogContent with required bloc outside of this widget
class DialogHelper {
  Widget dialogContent;
  bool isModal;
  bool rootNavigator;

  DialogHelper(
      {this.dialogContent, this.isModal = false, this.rootNavigator = false});

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
                  insetPadding: EdgeInsets.symmetric(horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: SizedBox(
                      width: App.REF_DEVICE_WIDTH,
                      child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24.0, vertical: 4.0),
                                    child: dialogContent)
                              ])))));
        });
  }
}
