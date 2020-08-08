import 'package:crypto_tracker/screens/coins.dart';
import 'package:crypto_tracker/screens/home.dart';
import 'package:flutter/cupertino.dart';

import 'constants/screen-titles.dart';

class AppNavigation {

  static Map<String, WidgetBuilder> routes = {
    '/': (BuildContext context) => HomeScreen(title: ScreenTitles.HOME_SCREEN),
    '/coins': (BuildContext context) => CoinsScreen(title: ScreenTitles.COINS_SCREEN)
  };

}
