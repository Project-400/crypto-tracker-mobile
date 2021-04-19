import 'package:crypto_tracker/screens/general/bot-finished.dart';
import 'package:crypto_tracker/screens/general/bot-logs.dart';
import 'package:crypto_tracker/screens/general/coins.dart';
import 'package:crypto_tracker/screens/auth/confirm-email.dart';
import 'package:crypto_tracker/screens/general/home.dart';
import 'package:crypto_tracker/screens/general/best-performers.dart';
import 'package:crypto_tracker/screens/landing.dart';
import 'package:crypto_tracker/screens/general/price-charts.dart';
import 'package:crypto_tracker/screens/auth/sign-up.dart';
import 'package:crypto_tracker/screens/general/deploy-bot.dart';
import 'package:flutter/cupertino.dart';
import 'constants/navigation-routes.dart';
import 'constants/screen-titles.dart';

class AppNavigation {

  static Map<String, WidgetBuilder> routes = {
    NavigationRoutes.LANDING_SCREEN: (BuildContext context) => LandingScreen(title: ScreenTitles.LANDING_SCREEN),
    NavigationRoutes.HOME_SCREEN: (BuildContext context) => HomeScreen(title: ScreenTitles.HOME_SCREEN),
    NavigationRoutes.SIGN_UP_SCREEN: (BuildContext context) => SignUpScreen(title: ScreenTitles.SIGN_UP_SCREEN),
    NavigationRoutes.CONFIRM_EMAIL_SCREEN: (BuildContext context) => ConfirmEmailScreen(title: ScreenTitles.CONFIRM_EMAIL_SCREEN),
    NavigationRoutes.LOGIN_SCREEN: (BuildContext context) => SignUpScreen(title: ScreenTitles.SIGN_UP_SCREEN),
    NavigationRoutes.COINS_SCREEN: (BuildContext context) => CoinsScreen(title: ScreenTitles.COINS_SCREEN),
    NavigationRoutes.BEST_PERFORMERS: (BuildContext context) => BestPerformersScreen(title: ScreenTitles.BEST_PERFORMERS),
    NavigationRoutes.DEPLOY_BOT: (BuildContext context) => DeployBotScreen(title: ScreenTitles.DEPLOY_BOT),
    NavigationRoutes.BOT_FINISHED: (BuildContext context) => BotFinishedScreen(title: ScreenTitles.BOT_FINISHED),
    NavigationRoutes.PRICE_CHARTS: (BuildContext context) => PriceChartsScreen(title: ScreenTitles.PRICE_CHARTS),
    NavigationRoutes.BOT_LOGS: (BuildContext context) => BotLogsScreen(title: ScreenTitles.BOT_LOGS)
  };

}
