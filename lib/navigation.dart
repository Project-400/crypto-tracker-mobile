import 'package:crypto_tracker/screens/bot-finished.dart';
import 'package:crypto_tracker/screens/coins.dart';
import 'package:crypto_tracker/screens/home.dart';
import 'package:crypto_tracker/screens/best-performers.dart';
import 'package:crypto_tracker/screens/price-charts.dart';
import 'package:crypto_tracker/screens/subscribe.dart';
import 'package:flutter/cupertino.dart';
import 'constants/navigation-routes.dart';
import 'constants/screen-titles.dart';

class AppNavigation {

  static Map<String, WidgetBuilder> routes = {
    NavigationRoutes.HOME_SCREEN: (BuildContext context) => HomeScreen(title: ScreenTitles.HOME_SCREEN),
    NavigationRoutes.COINS_SCREEN: (BuildContext context) => CoinsScreen(title: ScreenTitles.COINS_SCREEN),
//    '/bot': (BuildContext context) => CryptoBotScreen(title: ScreenTitles.BOT_SCREEN),
    NavigationRoutes.BEST_PERFORMERS: (BuildContext context) => BestPerformersScreen(title: ScreenTitles.BEST_PERFORMERS),
    NavigationRoutes.SUBSCRIBE: (BuildContext context) => SubscribeScreen(title: ScreenTitles.SUBSCRIBE),
    NavigationRoutes.BOT_FINISHED: (BuildContext context) => BotFinishedScreen(title: ScreenTitles.BOT_FINISHED),
    NavigationRoutes.PRICE_CHARTS: (BuildContext context) => PriceChartsScreen(title: ScreenTitles.PRICE_CHARTS)
  };

}
