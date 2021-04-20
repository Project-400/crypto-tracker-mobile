import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:flutter/material.dart';

import 'confirm-email.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool isSigningUp = false;
  bool isSignedUp = false;
  String emailAddress;
  String password;
  String repeatPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/background2.jpeg'
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.9),
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
              Container(
                child: TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                      labelText: 'Repeat Password',
                      hintText: 'Repeat Password'
                  ),
                  onChanged: (pw) => repeatPassword = pw,
                ),
                padding: EdgeInsets.all(10),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 50, left: 10, right: 10),
                child: ElevatedButton(
                  child: Text(
                      'Sign Up',
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                  onPressed: signUp
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> signUp() async {
    setState(() {
      isSigningUp = true;
    });

    try {
      SignUpResult res = await Amplify.Auth.signUp(
          username: emailAddress,
          password: password,
          options: CognitoSignUpOptions(
              userAttributes: {
                'email': emailAddress
              }
          )
      );

      print(res);

      setState(() {
        isSignedUp = true;

        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            ConfirmEmailScreen(title: ScreenTitles.CONFIRM_EMAIL_SCREEN, email: emailAddress)
        ));
      });
    } on AuthException catch (e) {
      print(e.message);
    }

    setState(() {
      isSigningUp = false;
    });
  }

}
