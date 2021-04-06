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
      case ScreenTitles.HOME_SCREEN:
        currentIndex = 0;
        break;
      case ScreenTitles.COINS_SCREEN:
        currentIndex = 1;
        break;
      case ScreenTitles.PRICE_CHARTS:
        currentIndex = 2;
        break;
      case ScreenTitles.SUBSCRIBE:
        currentIndex = 3;
        break;
    }

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: ScreenTitles.HOME_SCREEN,
        ),
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
          label: ScreenTitles.SUBSCRIBE,
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.amber[800],
      onTap: (index) {
        String url = '/';
        switch (index) {
          case 0:
            url = NavigationRoutes.HOME_SCREEN;
            break;
          case 1:
            url = NavigationRoutes.COINS_SCREEN;
            break;
          case 2:
            url = NavigationRoutes.PRICE_CHARTS;
            break;
          case 3:
            url = NavigationRoutes.SUBSCRIBE;
            break;
        }
        Navigator.pushNamed(context, url);
      },
    );
  }
}
