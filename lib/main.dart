import 'package:flutter/material.dart';

import 'constants/screen-titles.dart';
import 'navigation.dart';

void main() {
  runApp(CryptoTrackerApp());
}

class CryptoTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ScreenTitles.HOME_SCREEN,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: AppNavigation.routes,
    );
  }
}
