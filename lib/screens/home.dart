import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:crypto_tracker/components/bottom-navigation.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:crypto_tracker/screens/confirm-email.dart';
import 'package:crypto_tracker/screens/login.dart';
import 'package:crypto_tracker/screens/sign-up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:aws_sns_api/sns-2010-03-31.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, email}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              widget.title,
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.logout),
                onPressed: Amplify.Auth.signOut,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(selectedScreen: ScreenTitles.HOME_SCREEN),
//        extendBodyBehindAppBar: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
//              Container(
//                child: SvgPicture.asset(
//                  'assets/bitcoin.svg',
//                  semanticsLabel: 'Preparing Bot',
//                  placeholderBuilder: (BuildContext context) => Container(
//                      padding: const EdgeInsets.all(30.0),
//                      child: const CircularProgressIndicator()
//                  ),
//                  height: 300,
//                ),
//                padding: EdgeInsets.symmetric(vertical: 80, horizontal: 10),
//              ),
              navigationButtonWithScreen(context, 'Sign Up', MaterialPageRoute(builder: (context) =>
                  SignUpScreen(title: ScreenTitles.SIGN_UP_SCREEN)
                )
              ),
              navigationButtonWithScreen(context, 'Confirm Email', MaterialPageRoute(builder: (context) =>
                  ConfirmEmailScreen(title: ScreenTitles.CONFIRM_EMAIL_SCREEN, email: 'chazooo555@gmail.com',)
                )
              ),
              navigationButtonWithScreen(context, 'Login', MaterialPageRoute(builder: (context) =>
                  LoginScreen(title: ScreenTitles.LOGIN_SCREEN,)
                )
              ),
              ElevatedButton(
                onPressed: () async {
                  print(Amplify.Auth.getCurrentUser());
                  print(await Amplify.Auth.getCurrentUser());
                  print((await Amplify.Auth.getCurrentUser()).userId);
                  print((await Amplify.Auth.getCurrentUser()).username);
                }, child: Text('Current User')
              ),
              ElevatedButton(
                onPressed: () {
                  Amplify.Auth.signOut();
                }, child: Text('Logout')
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget navigationButton(BuildContext context, String text, String url) {
    return Container(
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, url);
        },
        color: Colors.lightBlue,
        textColor: Colors.white,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
    );
  }

  Widget navigationButtonWithScreen(BuildContext context, String text, MaterialPageRoute screenRoute) {
    return Container(
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16
          ),
        ),
        onPressed: () {
          Navigator.push(context, screenRoute);
        },
        color: Colors.lightBlue,
        textColor: Colors.white,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
    );
  }

//  void test() {
//    final service = SNS(region: 'eu-west-1');
//
//    var params = {
//      'protocol': 'STRING_VALUE', /* required */
//      'topicArn': 'STRING_VALUE', /* required */
//      'endpoint': 'STRING_VALUE'
//    };
//
//    service.subscribe(protocol: '', topicArn: '', endpoint: '');
//  }
}
