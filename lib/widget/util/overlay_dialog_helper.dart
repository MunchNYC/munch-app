import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';

class OverlayDialogHelper {
  bool isModal;
  Widget widget;
  bool useRootNavigator;
  bool transparent;

  OverlayDialogHelper({this.isModal = false, this.widget, this.useRootNavigator = true, this.transparent = false});

  void show(BuildContext context) {
    showGeneralDialog(
        context: context,
        useRootNavigator: useRootNavigator,
        barrierDismissible: !isModal,
        barrierLabel: "",
        barrierColor: transparent ? Colors.transparent : Palette.secondaryLight.withAlpha(150),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
          return WillPopScope(
              onWillPop: () async {
                return !isModal;
              },
              child: widget);
        });
  }
}
