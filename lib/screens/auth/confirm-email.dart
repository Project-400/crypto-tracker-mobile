import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:crypto_tracker/screens/auth/login.dart';
import 'package:flutter/material.dart';

class ConfirmEmailScreen extends StatefulWidget {
  ConfirmEmailScreen({Key key, this.title, this.email}) : super(key: key);

  final String title;
  final String email;

  @override
  _ConfirmEmailScreenState createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {

  bool isConfirming = false;
  bool isSignUpComplete = false;
  String confirmationCode;

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
            if (widget.email != null) Text(widget.email),
            Container(
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Confirmation Code',
                    hintText: 'Confirmation Code'
                ),
                onChanged: (code) => confirmationCode = code,
              ),
              padding: EdgeInsets.all(10),
            ),
            ElevatedButton(
                child: Text('Confirm Email'),
                onPressed: confirmEmail
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

  Future<void> confirmEmail() async {
    setState(() {
      isConfirming = true;
    });

    try {
      SignUpResult res = await Amplify.Auth.confirmSignUp(
          username: widget.email,
          confirmationCode: confirmationCode
      );

      print(res);

      setState(() {
        isConfirming = false;
        isSignUpComplete = res.isSignUpComplete;

        if (res.isSignUpComplete) {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              LoginScreen(title: ScreenTitles.LOGIN_SCREEN, directedEmail: widget.email)
          ));
        }
      });
    } on AuthException catch (e) {
      print(e.message);
    }

    setState(() {
      isConfirming = false;
    });
  }

}
