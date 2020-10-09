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

class ProfileTab extends StatefulWidget {
  @override
  State<ProfileTab> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTab> {
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
    // All this logic is made in order to have footer at the bottom of scroll view if scrollable, or at the bottom of the page if view fits less then max height of the screen
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            padding: AppDimensions.padding(AppPaddingType.screenOnly).copyWith(bottom: 8.0),
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minHeight: constraints.maxHeight - kToolbarHeight, // kToolbarHeight gives approx. height of appBar/bottomNavigationBar
                maxHeight: double.infinity,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _avatarRow(),
                    SizedBox(height: 4.0),
                    _menuListItemDivider(),
                    _menuItems(),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(App.translate("account_tab.version.text") + " " + AppConfig.getInstance().packageInfo.version,
                          style: AppTextStyle.style(AppTextStylePattern.body)
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Widget _menuListItemDivider(){
    return Divider(height: 44.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.3));
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
            Text(user.displayName, style: AppTextStyle.style(AppTextStylePattern.heading2, fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.fade),
            SizedBox(height: 4.0),
            Text(user.email, style: AppTextStyle.style(AppTextStylePattern.heading6, fontSizeOffset: 1.0, fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.fade)
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
          AccountTabMenuItem(text: App.translate("account_tab.menu_item1.text"),
              onTap: _onNotificationsItemClicked,
              trailingIcon: ImageIcon(AssetImage("assets/icons/notification.png"), size: AppDimensions.scaleSizeToScreen(28.0))
          ),
          _menuListItemDivider(),
          AccountTabMenuItem(text: App.translate("account_tab.menu_item2.text"),
              onTap: _onInviteFriendsItemClicked,
              trailingIcon: ImageIcon(AssetImage("assets/icons/inviteFriends.png"), size: AppDimensions.scaleSizeToScreen(28.0))
          ),
          _menuListItemDivider(),
          AccountTabMenuItem(text: App.translate("account_tab.menu_item3.text"),
              onTap: _onFeedbackItemClicked,
              trailingIcon: ImageIcon(AssetImage("assets/icons/giveUsFeedback.png"), size: AppDimensions.scaleSizeToScreen(28.0))
          ),
          _menuListItemDivider(),
          AccountTabMenuItem(text: App.translate("account_tab.menu_item4.text"),
              onTap: _onPrivacyItemClicked,
              trailingIcon: ImageIcon(AssetImage("assets/icons/privacy.png"), size: AppDimensions.scaleSizeToScreen(28.0))
          ),
          _menuListItemDivider(),
          AccountTabMenuItem(text: App.translate("account_tab.menu_item5.text"),
              onTap: _onTermsItemClicked,
              trailingIcon: ImageIcon(AssetImage("assets/icons/termsAndConditions.png"), size: AppDimensions.scaleSizeToScreen(28.0))
          ),
          _menuListItemDivider(),
          AccountTabMenuItem(text: App.translate("account_tab.menu_item6.text"),
              onTap: _onSignOutItemClicked,
              trailingIcon: ImageIcon(AssetImage("assets/icons/logout.png"), size: AppDimensions.scaleSizeToScreen(28.0))
          ),
          _menuListItemDivider(),
        ]
    );
  }

  void _onNotificationsItemClicked(){
    AppSettings.openAppSettings();
  }

  void _onInviteFriendsItemClicked() async{
    await WcFlutterShare.share(
        sharePopupTitle: App.translate("account_tab.invite_friends.item.share_popup.title"),
        text: App.translate("account_tab.invite_friends.item.share_popup.text") + "\n" + "https://munch.com",
        mimeType: "text/plain"
    );
  }

  void _onFeedbackItemClicked() async{
    Utility.launchUrl(context, "mailto:" + AppConfig.getInstance().supportEmail);
  }

  void _onPrivacyItemClicked() async{
    NavigationHelper.navigateToPrivacyPolicyScreen(context);
  }

  void _onTermsItemClicked() async{
    NavigationHelper.navigateToTermsOfServiceScreen(context);
  }

  void _onSignOutItemClicked() {
    _authenticationBloc.add(LogoutEvent());

    NavigationHelper.navigateToLogin(context, addToBackStack: false);
  }
}
