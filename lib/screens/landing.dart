import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

checkIfAuthenticated() async {
  await Future.delayed(Duration(seconds: 1));
  final session = await Amplify.Auth.fetchAuthSession();
//  await Future.delayed(Duration(seconds: 2));
//  return true;
  return session.isSignedIn;
}

class LandingScreen extends StatefulWidget {
  LandingScreen({Key key, this.title, email}) : super(key: key);

  final String title;

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
      if (success) {
        Navigator.pushReplacementNamed(context, '/price-charts');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: SvgPicture.asset(
              'assets/bitcoin.svg',
              semanticsLabel: 'Preparing Bot',
              placeholderBuilder: (BuildContext context) => Container(
                  padding: const EdgeInsets.all(30.0),
                  child: const CircularProgressIndicator()
              ),
              height: 300,
            ),
            padding: EdgeInsets.symmetric(vertical: 80, horizontal: 10),
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }

}
