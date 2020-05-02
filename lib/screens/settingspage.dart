import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Information"),
        ),
        body: settingsView());
  }

  Widget settingsView() {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: <Widget>[
        ListTile(
          trailing: Icon(
            Icons.info,
            color: Theme.of(context).primaryColor,
          ),
          title: Text('About'),
          onTap: () async {
            // Update the state of the app
            PackageInfo packageInfo = await PackageInfo.fromPlatform();
            _showAboutDialog(packageInfo.appName, packageInfo.version);
          },
        ),
        Divider(
          color: Colors.grey,
        ),
        ListTile(
          trailing: Icon(
            Icons.rate_review,
            color: Theme.of(context).primaryColor,
          ),
          title: Text('Rate'),
          onTap: () {
            // Update the state of the app
            //_launchURL("https://play.google.com/store/apps/details?id=com.hungrydroid.whackavirus");
          },
        ),
        Divider(
          color: Colors.grey,
        ),
        ListTile(
          trailing: Icon(
            Icons.share,
            color: Theme.of(context).primaryColor,
          ),
          title: Text('Share'),
          onTap: () {
            // Update the state of the app

            Share.share(
                "https://play.google.com/store/apps/details?id=com.hungrydroid.whackavirus");
          },
        ),
        Divider(
          color: Colors.grey,
        ),
        ListTile(
          trailing: Icon(
            Icons.info,
            color: Theme.of(context).primaryColor,
          ),
          title: Text('More Apps'),
          onTap: () async {
            // Update the state of the app
            _launchURL(
                "https://play.google.com/store/apps/developer?id=SimpleApp+Android");
          },
        )
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(String name, String version) {
    Alert(
      context: context,
      image: Image.asset(
        "images/virus.png",
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width / 3,
      ),
      title: name + " " + version,
      style: AlertStyle(isOverlayTapDismiss: false, isCloseButton: false),
      buttons: [
        DialogButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            "Close",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }
}
