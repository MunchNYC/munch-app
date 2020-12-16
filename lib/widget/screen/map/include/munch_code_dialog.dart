import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class MunchCodeDialog extends StatelessWidget {
  Munch munch;

  MunchCodeDialog(this.munch);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      _titleText(),
      SizedBox(height: 20.0),
      _munchCodeContainer(context),
      SizedBox(height: 16.0),
      _continueButton(context)
    ]);
  }

  Widget _titleText() {
    return Text(App.translate("munch_code_dialog.title"),
        style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center);
  }

  Widget _copyButton(BuildContext context) {
    return CustomButton(
      padding: EdgeInsets.zero,
      color: Colors.transparent,
      flat: true,
      content: Icon(Icons.content_copy, color: Palette.primary, size: 20.0),
      onPressedCallback: () {
        Clipboard.setData(ClipboardData(text: munch.joinLink));

        Utility.showFlushbar(App.translate("munch_code_dialog.copy_action.successful"), context,
            duration: Duration(seconds: 1));
      },
    );
  }

  Widget _shareButton() {
    return CustomButton(
      padding: EdgeInsets.zero,
      color: Colors.transparent,
      flat: true,
      content: ImageIcon(
        AssetImage("assets/icons/share.png"),
        color: Palette.primary,
        size: 18.0,
      ),
      onPressedCallback: () async {
        await WcFlutterShare.share(
            sharePopupTitle: App.translate("munch_code_dialog.share_button.popup.title"),
            text: App.translate("munch_code_dialog.share_action.text") + "\n" + munch.joinLink,
            mimeType: "text/plain");
      },
    );
  }

  Widget _munchCodeContainer(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0), border: Border.all(width: 1.0, color: Palette.secondaryDark)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _copyButton(context),
            SizedBox(width: 8.0),
            Text(munch.code,
                style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
            SizedBox(width: 8.0),
            _shareButton()
          ],
        ));
  }

  Widget _continueButton(BuildContext context) {
    return CustomButton(
      elevation: 4.0,
      minWidth: double.infinity,
      borderRadius: 12.0,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      content: Text(App.translate("munch_code_dialog.continue_button.text"),
          style:
              AppTextStyle.style(AppTextStylePattern.body3Inverse, fontWeight: FontWeight.w600, fontSizeOffset: 1.0)),
      onPressedCallback: () {
        // pop modal dialog
        NavigationHelper.popRoute(context, rootNavigator: false);

        // pop map screen, cannot replace route because this route is not in rootNavigator
        NavigationHelper.popRoute(context, rootNavigator: false);

        NavigationHelper.navigateToRestaurantSwipeScreen(context, munch: munch);
      },
    );
  }
}
