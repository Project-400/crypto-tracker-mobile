import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

checkIfAuthenticated() async {
//  await Future.delayed(Duration(seconds: 5));  // could be a long running task, like a fetch from keychain
  final session = await Amplify.Auth.fetchAuthSession();
  print(session);
  print(session.isSignedIn);
  return session.isSignedIn;
//  return true;
}

class LandingScreen extends StatefulWidget {
  LandingScreen({Key key, this.title, email}) : super(key: key);

  final String title;
//  bool loggedIn = false;

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkIfAuthenticated().then((success) {
      print('success');
      print(success);
      if (success) {
        Navigator.pushReplacementNamed(context, '/price-charts');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    return Center(
      child: CircularProgressIndicator(),
    );
  }

}
