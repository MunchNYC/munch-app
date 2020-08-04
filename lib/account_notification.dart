import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

class AccountNotification extends StatefulWidget {
  @override
  _AccountNotificationState createState() => _AccountNotificationState();
}

class _AccountNotificationState extends State<AccountNotification> {
  bool _munchReminder = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  title: Text('App Notification Settings'),
                  onTap: () {
                    AppSettings.openAppSettings();
                  },
                  trailing: Icon(Icons.chevron_right,
                      color: Colors.grey, size: 10 * 2.5),
                ),
                SwitchListTile(
                  title: Text('Munch Reminder'),
                  value: _munchReminder,
                  onChanged: (bool value) {
                    setState(() {
                      _munchReminder = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
