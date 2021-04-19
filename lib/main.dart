import 'package:amplify_api/amplify_api.dart';
import 'package:crypto_tracker/redux/coins/coins.state.dart';
import 'package:crypto_tracker/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

import 'auth/auth.dart';
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

  @override
  State<StatefulWidget> initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    print('debug 1');
    if (!mounted) return;
    print('debug 2');

    Amplify.addPlugin(AmplifyAuthCognito());
    Amplify.addPlugin(AmplifyAPI());
    print('debug 3');

    try {
      await Amplify.configure(amplifyconfig);
      print('Amplify successfully configured');
    } on AmplifyAlreadyConfiguredException catch (e) {
      print(1);
      print(e);
      print('Amplify was already configured.');
    } on AmplifyException catch (e) {
      print(2);
      print(e);
      print('Amplify may have already been configured.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider2>(
          create: (_) {
            return AuthProvider2();
          },
        )
      ],
      child: MaterialApp(
        title: ScreenTitles.HOME_SCREEN,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: AppNavigation.routes,
      ),
    );


//    return StoreProvider<CoinsState>(
//      store: store,
//      child: MaterialApp(
//        title: ScreenTitles.HOME_SCREEN,
//        theme: ThemeData(
//          primarySwatch: Colors.blue,
//          visualDensity: VisualDensity.adaptivePlatformDensity,
//        ),
//        routes: AppNavigation.routes,
//      ),
//    );
  }

}
