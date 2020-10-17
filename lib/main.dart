import 'package:crypto_tracker/redux/coins/coins.state.dart';
import 'package:crypto_tracker/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'constants/screen-titles.dart';
import 'navigation.dart';

import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';

void main() {
  runApp(CryptoTrackerApp(store: store));
}

class CryptoTrackerApp extends StatelessWidget {
  final Store<CoinsState> store;

  CryptoTrackerApp({ this.store });

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
