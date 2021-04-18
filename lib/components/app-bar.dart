import 'package:crypto_tracker/auth/check-auth.dart';
import 'package:flutter/material.dart';

import 'confirm-logout-dialog.dart';

class AuthAppBar extends StatefulWidget {
  AuthAppBar({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<AuthAppBar> {
  bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    checkIfAuthenticated().then((success) {
      isLoggedIn = success;
    });

    return AppBar(
      title: Text(
        widget.title,
      ),
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
    );
  }

}
