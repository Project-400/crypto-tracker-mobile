import 'package:amplify_flutter/amplify.dart';
import 'package:crypto_tracker/constants/navigation-routes.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:flutter/material.dart';

showConfirmLogoutDialog(BuildContext context) {
  Widget cancelButton = FlatButton(
    child: Text('Cancel'),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text('Logout'),
    onPressed: () async {
      await Amplify.Auth.signOut();
      Navigator.pop(context);
      Navigator.pushNamed(context, NavigationRoutes.HOME_SCREEN);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text('Logout?'),
    content: Text('Are you sure you want to logout?'),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
