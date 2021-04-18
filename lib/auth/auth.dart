import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names
//Future<bool> LOGGED_IN() async {
//  try {
//    AuthUser user = await Amplify.Auth.getCurrentUser();
//
////    Amplify.Auth.fetchAuthSession()
//
//    if (user != null) return true;
//    return false;
//  } on SignedOutException {
//    return false;
//  }

//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  bool isLoggedIn = prefs.getBool('isLoggedIn');
//
//  return isLoggedIn;
//}
//
//class AuthHandler extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new FutureBuilder<bool>(
//        future: LOGGED_IN(),
//        builder: (_, AsyncSnapshot<bool> loggedIn)
//        => loggedIn ? true : false;
//    );
//  }
//}

import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider2 with ChangeNotifier {
  AuthUser user;
  bool loggedIn = false;
  StreamSubscription userAuthSub;
  String lastHubEvent = '';

  AuthProvider2() {
//    userAuthSub =   Amplify.Auth.getCurrentUser().listen((newUser) {
//      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
//      user = newUser;
//      notifyListeners();
//    }, onError: (e) {
//      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
//    });

    userAuthSub = Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
      print(hubEvent.toString());
      loggedIn = hubEvent.isSignedIn;

      switch (hubEvent.eventName) {
        case 'SIGNED_IN':
          {
            lastHubEvent = 'SIGNED_IN';
            print('HUB: USER IS SIGNED IN');
          }
          break;
        case 'SIGNED_OUT':
          {
            lastHubEvent = 'SIGNED_OUT';
            print('HUB: USER IS SIGNED OUT');
          }
          break;
        case 'SESSION_EXPIRED':
          {
            lastHubEvent = 'SESSION_EXPIRED';
            print('HUB: USER SESSION HAS EXPIRED');
          }
          break;
      }
    });

    print(lastHubEvent);
  }

  @override
  void dispose() {
    if (userAuthSub != null) {
      userAuthSub.cancel();
      userAuthSub = null;
    }
    super.dispose();
  }

//  bool get isAnonymous {
//    assert(user != null);
//    bool isAnonymousUser = true;
//    for (UserInfo info in user.providerData) {
//      if (info.providerId == "facebook.com" ||
//          info.providerId == "google.com" ||
//          info.providerId == "password") {
//        isAnonymousUser = false;
//        break;
//      }
//    }
//    return isAnonymousUser;
//  }

  String get isAuthenticated {
    print('USER CHECK');
    return lastHubEvent;
  }

//  void signInAnonymously() {
//    FirebaseAuth.instance.signInAnonymously();
//  }

//  void signOut() {
//    FirebaseAuth.instance.signOut();
//  }
}
