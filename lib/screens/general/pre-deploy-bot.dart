import 'dart:async';
import 'dart:convert';

import 'package:crypto_tracker/auth/check-auth.dart';
import 'package:crypto_tracker/components/bottom-navigation.dart';
import 'package:crypto_tracker/components/confirm-logout-dialog.dart';
import 'package:crypto_tracker/constants/enums.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:crypto_tracker/models/bot-log.dart';
import 'package:crypto_tracker/screens/general/bot-finished.dart';
import 'package:crypto_tracker/screens/general/deploy-bot.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PreDeployBotScreen extends StatefulWidget {
  PreDeployBotScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PreDeployBotScreenState createState() => _PreDeployBotScreenState();
}

class _PreDeployBotScreenState extends State<PreDeployBotScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkIfAuthenticated().then((success) {
      setState(() {
        isLoggedIn = success;
      });
    });

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            automaticallyImplyLeading: false,
            actions: [
              if (isLoggedIn) Padding(
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () => showConfirmLogoutDialog(context),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(selectedScreen: ScreenTitles.DEPLOY_BOT),
          body: Center(
            child: Row(
              children: [
//                deploymentTypeButton('Manual Setup', () => Navigator.push(MaterialPageRoute(builder: (context) => DeployBotScreen(title: 'Bot Finished', botId: botId)))),
//                deploymentTypeButton('Auto Setup'),
              ],
            ),
          ),
        )
    );
  }

  Widget deploymentTypeButton(String text, Function onPressed) {
    return Container(
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16
          ),
        ),
        onPressed: onPressed,
//        color: isBotWorking ? Colors.red : Colors.lightBlue,
        textColor: Colors.white,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
  }

}
