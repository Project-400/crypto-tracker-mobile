import 'package:crypto_tracker/components/confirm-logout-dialog.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:crypto_tracker/screens/auth/login.dart';
import 'package:crypto_tracker/screens/auth/sign-up.dart';
import 'package:flutter/material.dart';
import '../../auth/check-auth.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, email}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkIfAuthenticated().then((success) {
      setState(() {
        isLoggedIn = success;
      });
    });

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
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
        ),
        body: Center(
          child:
            DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/background2.jpeg'
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        navigationButtonWithScreen(context, 'Login', true, MaterialPageRoute(builder: (context) =>
                            LoginScreen(title: ScreenTitles.LOGIN_SCREEN,)
                        )),
                        navigationButtonWithScreen(context, 'Sign Up', false, MaterialPageRoute(builder: (context) =>
                            SignUpScreen(title: ScreenTitles.SIGN_UP_SCREEN,)
                        )),
                      ],
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
                padding: EdgeInsets.only(bottom: 60),
              ),
            ),
        ),
      ),
    );
  }

  Widget navigationButtonWithScreen(BuildContext context, String text, bool isLeft, MaterialPageRoute screenRoute) {
    return Expanded(
      child: Container(
        child: ElevatedButton(
          child: Container(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 20),
          ),
          onPressed: () {
            Navigator.push(context, screenRoute);
          },
        ),
        padding: isLeft ? EdgeInsets.only(left: 10, right: 5) : EdgeInsets.only(left: 5, right: 10),
      )
    );
  }

}
