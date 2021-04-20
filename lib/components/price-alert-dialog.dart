import 'package:crypto_tracker/constants/navigation-routes.dart';
import 'package:flutter/material.dart';

showPriceAlertDialog(BuildContext context) {
  Widget cancelButton = FlatButton(
    child: Text('Cancel'),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text('View'),
    onPressed: () async {
      Navigator.pop(context);
      Navigator.pushNamed(context, NavigationRoutes.PRICE_ALERTS);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text('Price Alert'),
    content: Text('You have a new price alert to view'),
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
