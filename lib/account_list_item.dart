import 'package:munch/account_privacy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'account_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

enum accountListItem {
  EditProfile,
  ReferFriend,
  Notifications,
  Privacy,
  Support,
  SignOut
}

class AccountListItem extends StatelessWidget {
  final IconData icon;
  final text;
  final bool hasNavigation;
  final accountListItem itemType;

  const AccountListItem(
      {Key key, this.hasNavigation, this.icon, this.text, this.itemType})
      : super(key: key);

  SnackBar _emailSnackBar() {
    return SnackBar(
      content:
          Text('Failed to launch Email. Contact us at: munchappdev@gmail.com'),
    );
  }

  void _referFriendShare(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final String text =
        'This Awesome app called Munch helps us find a distinct place to feast! www.google.com';
    Share.share(text,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void _launchDeviceDefaults(BuildContext context, command, error) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      Scaffold.of(context).showSnackBar(error);
    }
  }

  void _launchEmailDeviceDefaults(BuildContext context) {
    const command = 'mailto:munchappdev@gmail.com';
    _launchDeviceDefaults(context, command, _emailSnackBar());
  }

  _accountListItemActions(BuildContext context) {
    switch (this.itemType) {
      case accountListItem.Privacy:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccountPrivacy()));
        break;
      case accountListItem.ReferFriend:
        _referFriendShare(context);
        break;
      case accountListItem.Support:
        _launchEmailDeviceDefaults(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _accountListItemActions(context);
      },
      child: Container(
        height: spacingUnit.w * 5.5,
        margin: EdgeInsets.symmetric(horizontal: spacingUnit.w * 4)
            .copyWith(bottom: spacingUnit.w * 2),
        padding: EdgeInsets.symmetric(horizontal: spacingUnit.w * 2),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: Offset(2, 2)),
            ],
            borderRadius: BorderRadius.circular(spacingUnit.w * 3),
            color: Colors.white),
        //Theme.of(context).backgroundColor),
        child: Row(
          children: <Widget>[
            Icon(
              this.icon,
              size: spacingUnit.w * 3,
            ),
            SizedBox(width: spacingUnit.w * 2.5),
            Text(
              this.text,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)
                  .copyWith(),
            ),
            Spacer(),
            if (this.hasNavigation)
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: spacingUnit.w * 2.5,
              ),
          ],
        ),
      ),
    );
  }
}
