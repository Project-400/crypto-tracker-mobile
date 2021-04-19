import 'package:crypto_tracker/constants/navigation-routes.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key key, this.selectedScreen}) : super(key: key);

  final String selectedScreen;

  @override
  Widget build(BuildContext context) {
    num currentIndex = 0;

    switch(selectedScreen) {
//      case ScreenTitles.HOME_SCREEN:
//        currentIndex = 0;
//        break;
      case ScreenTitles.COINS_SCREEN:
        currentIndex = 0;
        break;
      case ScreenTitles.PRICE_CHARTS:
        currentIndex = 1;
        break;
      case ScreenTitles.DEPLOY_BOT:
        currentIndex = 2;
        break;
      case ScreenTitles.BEST_PERFORMERS:
        currentIndex = 3;
        break;
      case ScreenTitles.BOT_LOGS:
        currentIndex = 4;
        break;
    }

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[

        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: ScreenTitles.COINS_SCREEN,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart_sharp),
          label: ScreenTitles.PRICE_CHARTS,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.queue_outlined),
          label: ScreenTitles.DEPLOY_BOT,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: ScreenTitles.BEST_PERFORMERS,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted),
          label: ScreenTitles.BOT_LOGS,
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.amber[800],
      onTap: (index) {
        String url = '/';
        switch (index) {
//          case 0:
//            url = NavigationRoutes.HOME_SCREEN;
//            break;
          case 0:
            url = NavigationRoutes.COINS_SCREEN;
            break;
          case 1:
            url = NavigationRoutes.PRICE_CHARTS;
            break;
          case 2:
            url = NavigationRoutes.DEPLOY_BOT;
            break;
          case 3:
            url = NavigationRoutes.BEST_PERFORMERS;
            break;
          case 4:
            url = NavigationRoutes.BOT_LOGS;
            break;
        }
        Navigator.pushNamed(context, url);
      },
    );
  }
}
