import 'package:crypto_tracker/screens/bot-finished.dart';
import 'package:crypto_tracker/screens/coins.dart';
import 'package:crypto_tracker/screens/home.dart';
import 'package:crypto_tracker/screens/best-performers.dart';
import 'package:crypto_tracker/screens/price-charts.dart';
import 'package:crypto_tracker/screens/subscribe.dart';
import 'package:flutter/cupertino.dart';

import 'constants/screen-titles.dart';

class AppNavigation {

  static Map<String, WidgetBuilder> routes = {
    '/': (BuildContext context) => HomeScreen(title: ScreenTitles.HOME_SCREEN),
    '/coins': (BuildContext context) => CoinsScreen(title: ScreenTitles.COINS_SCREEN),
//    '/bot': (BuildContext context) => CryptoBotScreen(title: ScreenTitles.BOT_SCREEN),
    '/best-performers': (BuildContext context) => BestPerformersScreen(title: ScreenTitles.BEST_PERFORMERS),
    '/subscribe': (BuildContext context) => SubscribeScreen(title: ScreenTitles.SUBSCRIBE),
    '/bot-finished': (BuildContext context) => BotFinishedScreen(title: ScreenTitles.BOT_FINISHED),
    '/price-charts': (BuildContext context) => PriceChartsScreen(title: ScreenTitles.PRICE_CHARTS)
  };

}
