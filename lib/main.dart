import 'package:crypto_tracker/redux/coins/coins.state.dart';
import 'package:crypto_tracker/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'constants/screen-titles.dart';
import 'navigation.dart';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(CryptoTrackerApp(store: store));
}

class CryptoTrackerApp extends StatefulWidget {
  final Store<CoinsState> store;

  CryptoTrackerApp({ this.store });

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CryptoTrackerApp> {
  bool _amplifyConfigured = false;

  @override
  State<StatefulWidget> initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    if (mounted) return; // Avoid reconfiguring Amplify or error will occur

    Amplify.addPlugin(AmplifyAuthCognito());

    try {
      await Amplify.configure(amplifyconfig);
      print('Amplify successfully configured');
    } on AmplifyAlreadyConfiguredException {
      print('Amplify was already configured. Was the app restarted?');
    }
    try {
      this.setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<CoinsState>(
      store: store,
      child: MaterialApp(
        title: ScreenTitles.HOME_SCREEN,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: AppNavigation.routes,
      ),
    );
  }

}
