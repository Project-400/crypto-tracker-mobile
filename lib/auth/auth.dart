import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class AuthProvider2 with ChangeNotifier {
  AuthUser user;
  bool loggedIn = false;
  StreamSubscription userAuthSub;
  String lastHubEvent = '';

  AuthProvider2() {
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

  String get isAuthenticated {
    return lastHubEvent;
  }
}
