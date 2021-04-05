import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

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
      SignInResult res = await Amplify.Auth.signIn(
          username: emailAddress,
          password: password,
      );

      print(res);

      setState(() {
        isLoggedIn = res.isSignedIn;
      });
    } on AuthException catch (e) {
      print(e.message);
    }

    setState(() {
      isLoggingIn = false;
    });
  }

}
