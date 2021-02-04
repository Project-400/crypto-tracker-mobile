import 'package:crypto_tracker/screens/bot-finished.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: SvgPicture.asset(
                  'assets/bitcoin.svg',
                  semanticsLabel: 'Preparing Bot',
                  placeholderBuilder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(30.0),
                      child: const CircularProgressIndicator()
                  ),
                  height: 300,
                ),
                padding: EdgeInsets.symmetric(vertical: 80, horizontal: 10),
              ),
              navigationButton(context, 'My Assets', '/coins'),
              navigationButton(context, 'Best Performers', '/best-performers'),
              navigationButton(context, 'Deploy Bot', '/subscribe'),
              navigationButtonWithScreen(context, 'Skip to Finished', MaterialPageRoute(builder: (context) => BotFinishedScreen(title: 'Bot Finished', botId: '32b6ed51-b267-4d22-84c7-9b794028c21b'))),
            ],
          ),
        ),
      ),
    );
  }

  Widget navigationButton(BuildContext context, String text, String url) {
    return Container(
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, url);
        },
        color: Colors.lightBlue,
        textColor: Colors.white,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
    );
  }

  Widget navigationButtonWithScreen(BuildContext context, String text, MaterialPageRoute screenRoute) {
    return Container(
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16
          ),
        ),
        onPressed: () {
          Navigator.push(context, screenRoute);
        },
        color: Colors.lightBlue,
        textColor: Colors.white,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
    );
  }
}
