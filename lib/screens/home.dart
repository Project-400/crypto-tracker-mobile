import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:crypto_tracker/auth/auth.dart';
import 'package:crypto_tracker/components/bottom-navigation.dart';
import 'package:crypto_tracker/components/confirm-logout-dialog.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:crypto_tracker/screens/confirm-email.dart';
import 'package:crypto_tracker/screens/login.dart';
import 'package:crypto_tracker/screens/sign-up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
//import 'package:aws_sns_api/sns-2010-03-31.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, email}) : super(key: key);

  final String title;
//  bool loggedIn = false;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    
//    isLoggedIn = await LOGGED_IN();
//
//    print('isLoggedIn');
//    print(isLoggedIn);

//    checkLoggedIn();

//    _isSignedIn();
  }

//  checkLoggedIn () async {
//    bool auth = await LOGGED_IN();
//
//    setState(() {
//      isLoggedIn = auth;
//      widget.loggedIn = auth;
//    });
//  }

//  Future<bool> _isSignedIn() async {
//    final session = await Amplify.Auth.fetchAuthSession();
//    print(session.isSignedIn);
//    setState(() {
//      isLoggedIn = session.isSignedIn;
//    });
//    return session.isSignedIn;
//  }

  @override
  Widget build(BuildContext context) {
//    AuthProvider2 authProvider = Provider.of(context);
//
//    print('authProvider.isAuthenticated');
//    print(authProvider.isAuthenticated);

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
//        bottomNavigationBar: BottomNavBar(selectedScreen: ScreenTitles.HOME_SCREEN),
//        extendBodyBehindAppBar: true,
        body: Center(
          child:
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
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
//              Container(
//                decoration: BoxDecoration(
//                  image: DecorationImage(
//                    image: AssetImage('assets/background.jpg'),
//                    fit: BoxFit.cover,
//                  ),
//                ),
//                child: null,
//              ),
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
//                          navigationButtonWithScreen(context, 'Sign Up', MaterialPageRoute(builder: (context) =>
//                              SignUpScreen(title: ScreenTitles.SIGN_UP_SCREEN)
//                          )
//                          ),
//                          navigationButtonWithScreen(context, 'Confirm Email', MaterialPageRoute(builder: (context) =>
//                              ConfirmEmailScreen(title: ScreenTitles.CONFIRM_EMAIL_SCREEN, email: 'chazooo555@gmail.com',)
//                          )
//                          ),
//                          navigationButtonWithScreen(context, 'Login', MaterialPageRoute(builder: (context) =>
//                              LoginScreen(title: ScreenTitles.LOGIN_SCREEN,)
//                          )
//                          ),
//                          ElevatedButton(
//                              onPressed: () async {
//                                print(Amplify.Auth.getCurrentUser());
//                                print(await Amplify.Auth.getCurrentUser());
//                                print((await Amplify.Auth.getCurrentUser()).userId);
//                                print((await Amplify.Auth.getCurrentUser()).username);
//                                print((await Amplify.Auth.fetchUserAttributes())[0].userAttributeKey);
//                                print((await Amplify.Auth.fetchUserAttributes())[0].value);
//                                print((await Amplify.Auth.fetchUserAttributes())[1].userAttributeKey);
//                                print((await Amplify.Auth.fetchUserAttributes())[1].value);
//                                print((await Amplify.Auth.fetchUserAttributes())[2].userAttributeKey);
//                                print((await Amplify.Auth.fetchUserAttributes())[2].value);
//                                await Amplify.Auth.fetchAuthSession().then((value) => print(value));
//                              }, child: Text('Current User')
//                          ),
//                          ElevatedButton(
//                              onPressed: () {
//                                Amplify.Auth.signOut();
//                              }, child: Text('Logout')
//                          ),
                                navigationButtonWithScreen2(context, 'Login', true, MaterialPageRoute(builder: (context) =>
                                    LoginScreen(title: ScreenTitles.LOGIN_SCREEN,)
                                )),
                                navigationButtonWithScreen2(context, 'Sign Up', false, MaterialPageRoute(builder: (context) =>
                                    LoginScreen(title: ScreenTitles.SIGN_UP_SCREEN,)
                                )),
//                                Expanded(
//                                    child: Container(
//                                      child: ElevatedButton(
//                                        child: Container(
//                                          child: Text(
//                                            'Sign Up',
//                                            style: TextStyle(
//                                                fontSize: 18
//                                            ),
//                                          ),
//                                          padding: EdgeInsets.symmetric(vertical: 20),
//                                        ),
//                                        onPressed: () {
//                                          Navigator.pushNamed(context, 'url');
//                                        },
//                                      ),
//                                      padding: EdgeInsets.only(left: 5, right: 10),
//                                    )
//                                )
                              ],
                            ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                      padding: EdgeInsets.only(bottom: 60),
                  ),
              ),

//            ],
//          ),
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

  Widget navigationButtonWithScreen2(BuildContext context, String text, bool isLeft, MaterialPageRoute screenRoute) {
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
