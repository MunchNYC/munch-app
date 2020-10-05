import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch/config/app_config.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/service/auth/authentication_bloc.dart';
import 'package:munch/service/auth/authentication_event.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/screen/home/include/account_tab_menu_item.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class AccountTab extends StatefulWidget {
  @override
  State<AccountTab> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountTab> {
  AuthenticationBloc _authenticationBloc;

  User user = UserRepo.getInstance().currentUser;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc();

    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: AppDimensions.padding(AppPaddingType.screenOnly),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _avatarRow(),
            SizedBox(height: 36.0),
            _menuItems()
          ],
        )
    );
  }

  Widget _avatarRow(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(backgroundImage: NetworkImage(user.photoUrl), radius: 36.0),
        SizedBox(width: 16.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.displayName, style: AppTextStyle.style(AppTextStylePattern.heading4, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.fade),
            SizedBox(height: 4.0),
            Text(App.translate("accounts_tab.profile_button.text"), style: AppTextStyle.style(AppTextStylePattern.body3SecondaryDark))
          ],
        )
      ]
    );
  }

  Widget _menuItems(){
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountTabMenuItem(text: App.translate("accounts_tab.menu_item1.text"), onTap: _onReferFriendItemClicked, trailingIcon: Icon(Icons.supervisor_account, size: 24.0)),
          Divider(height: 36.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.3)),
          AccountTabMenuItem(text: App.translate("accounts_tab.menu_item2.text"), onTap: _onNotificationsItemClicked, trailingIcon: Icon(Icons.notifications_none, size: 24.0)),
          Divider(height: 36.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.3)),
          AccountTabMenuItem(text: App.translate("accounts_tab.menu_item3.text"), onTap: _onPrivacyItemClicked, trailingIcon: Icon(Icons.security, size: 24.0)),
          Divider(height: 36.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.3)),
          AccountTabMenuItem(text: App.translate("accounts_tab.menu_item4.text"), onTap: _onSupportItemClicked, trailingIcon: Icon(Icons.email, size: 24.0)),
          Divider(height: 36.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.3)),
          AccountTabMenuItem(text: App.translate("accounts_tab.menu_item5.text"), onTap: _onSignOutItemClicked, trailingIcon: Icon(Icons.exit_to_app, size: 24.0)),
          Divider(height: 36.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.3)),
        ]
    );
  }

  void _onReferFriendItemClicked() async{
    await WcFlutterShare.share(
        sharePopupTitle: App.translate("accounts_tab.refer_a_friend.item.share_popup.title"),
        text: App.translate("accounts_tab.refer_a_friend.item.share_popup.text") + "\n" + "https://munch.com",
        mimeType: "text/plain"
    );
  }

  void _onNotificationsItemClicked(){
    AppSettings.openAppSettings();
  }

  void _onPrivacyItemClicked() async{

  }

  void _onSupportItemClicked() async{
    Utility.launchUrl(context, "mailto:" + AppConfig.getInstance().supportEmail);
  }

  void _onSignOutItemClicked() {
    _authenticationBloc.add(LogoutEvent());

    NavigationHelper.navigateToLogin(context, addToBackStack: false);
  }
}
