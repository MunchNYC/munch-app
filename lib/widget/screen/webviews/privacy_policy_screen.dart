import 'package:flutter/material.dart';
import 'package:munch/config/app_config.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/util/app_bar_back_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  Widget _appBar() {
    return AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading: AppBarBackButton(),
      title: Text(App.translate("privacy_policy_screen.app_bar.title"),
          style: AppTextStyle.style(AppTextStylePattern.heading6,
              fontWeight: FontWeight.w500, fontSizeOffset: 1.0)),
      centerTitle: true,
      backgroundColor: Palette.background,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: WebView(initialUrl: AppConfig.getInstance().privacyPolicyUrl));
  }
}
