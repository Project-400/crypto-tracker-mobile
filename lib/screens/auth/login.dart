import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:crypto_tracker/screens/general/price-charts.dart';
import 'package:flutter/material.dart';
import 'package:trading_chart/utils/date_format_util.dart';

import '../general/home.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title, this.directedEmail}) : super(key: key);

  final String title;
  final String directedEmail;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isLoggingIn = false;
  bool isLoggedIn = false;
  String emailAddress;
  String password;

  @override
  void initState() {
    super.initState();

    if (widget.directedEmail != null) emailAddress = widget.directedEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Email Address'
                ),
                onChanged: (email) => emailAddress = email,
                controller: TextEditingController(
                  text: widget.directedEmail
                ),
              ),
              padding: EdgeInsets.all(10),
            ),
            Container(
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password'
                ),
                onChanged: (pw) => password = pw,
              ),
              padding: EdgeInsets.all(10),
            ),
            ElevatedButton(
                child: Text('Login'),
                onPressed: login
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> login() async {
    setState(() {
      isLoggingIn = true;
    });

    try {
      print('emailAddress');
      print(emailAddress);
      SignInResult res = await Amplify.Auth.signIn(
          username: emailAddress,
          password: password,
      );

      print(res);

      setState(() {
        isLoggedIn = res.isSignedIn;

        if (res.isSignedIn) {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              PriceChartsScreen(title: ScreenTitles.PRICE_CHARTS)
          ));
        }
      });
    } on AuthException catch (e) {
      print(e.message);
    }

    setState(() {
      isLoggingIn = false;
    });
  }

}
