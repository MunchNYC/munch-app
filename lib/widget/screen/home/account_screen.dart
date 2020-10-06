import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:munch/service/auth/authentication_bloc.dart';
import 'package:munch/service/auth/authentication_event.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/widget/include/account_privacy.dart';
import 'include/account_list_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import '../../include/account_notification.dart';

const spacingUnit = 10;

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountScreenState();
  }
}

class _AccountScreenState extends State<AccountScreen> {
  PickedFile _image;
  final picker = ImagePicker();

  AuthenticationBloc _authenticationBloc;

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

  Future _getImage(ImageSource source) async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      _image = pickedFile;
    });
  }

  void _iOSShowActionSheet() {
    showCupertinoModalPopup(
        context: context, builder: (context) => _iOSActionSheet());
  }

  CupertinoActionSheet _iOSActionSheet() {
    return CupertinoActionSheet(
      title: Text('You Are Beautiful'),
      //message: Text('Camera or Photo Library?'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Photo Library'),
          onPressed: () => _getImage(ImageSource.gallery),
        ),
        CupertinoActionSheetAction(
          child: Text('Camera'),
          onPressed: () => _getImage(ImageSource.camera),
        ),
        CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: true,
        ),
      ],
    );
  }

  void _profileImageTappedAlt() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 180,
            child: Container(
              child: _profileImageBottomAlertControllerMenu(),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15),
                    topRight: const Radius.circular(15),
                  )),
            ),
          );
        });
  }

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

  void _pushPrivacy(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountPrivacy()));
  }

  void _pushNotificationScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AccountNotification()));
  }

  void _signOut() {
    _authenticationBloc.add(LogoutEvent());

    // MOCK-UP, should be put in bloc pattern, not a priority now
    NavigationHelper.navigateToLogin(context, addToBackStack: false);
  }

  Column _profileImageBottomAlertControllerMenu() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.photo),
          title: Text('Photo Library'),
          onTap: () => _getImage(ImageSource.gallery),
        ),
        ListTile(
          leading: Icon(Icons.photo_camera),
          title: Text('Camera'),
          onTap: () => _getImage(ImageSource.camera),
        ),
        ListTile(
          leading: Icon(
            Icons.cancel,
            color: Colors.red,
          ),
          title: Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () => Navigator.pop(context),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero, // must be set because of iOS devices, they will auto-add padding if not set
              children: <Widget>[
            SizedBox(height: spacingUnit.w * 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: spacingUnit.w * 5,
                      backgroundImage: _image == null
                          ? AssetImage('images/cloud cos.jpg')
                          : FileImage(File(_image.path)),
                      child: GestureDetector(
                        onTap: _iOSShowActionSheet,
                        //_profileImageTapped,
                      ),
                      backgroundColor: Colors.grey,
                    ),
                    SizedBox(height: spacingUnit.w * 2),
                    Text('Name Here',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Email Here', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            SizedBox(height: spacingUnit.w * 3),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: spacingUnit.w * 2),
                      AccountListItem(
                        icon: //Icons.people_outline,
                            LineAwesomeIcons.user_friends,
                        text: 'Refer a Friend',
                        hasNavigation: false,
                        target: () => _referFriendShare(context),
                      ),
                      AccountListItem(
                        icon: //Icons.notifications_none,
                            LineAwesomeIcons.bell,
                        text: 'Notifications',
                        hasNavigation: true,
                        target: () => _pushNotificationScreen(context),
                      ),
                      AccountListItem(
                        icon: //Icons.security,
                            LineAwesomeIcons.user_shield,
                        text: 'Privacy',
                        hasNavigation: true,
                        target: () => _pushPrivacy(context),
                      ),
                      AccountListItem(
                        icon: //Icons.mail_outline,
                            //LineAwesomeIcons.question_circle,
                            LineAwesomeIcons.envelope,
                        text: 'Support',
                        hasNavigation: false,
                        target: () => _launchEmailDeviceDefaults(context),
                      ),
                      AccountListItem(
                        icon: //Icons.exit_to_app,
                            //LineAwesomeIcons.alternate_sign_out,
                            LineAwesomeIcons.file_export,
                        text: 'Sign Out',
                        hasNavigation: false,
                        target: () => _signOut(),
                      ),
                      SizedBox(
                        height: spacingUnit.w * 2,
                      ),
                      Text('Version 1.0'),
                      SizedBox(
                        height: spacingUnit.w * 3,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        )));
  }
}
