import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text('My Coins'),
              onPressed: () {
                Navigator.pushNamed(context, '/coins');
              },
              color: Colors.lightBlue,
              textColor: Colors.white,
            ),
            FlatButton(
              child: Text('Crypto Bot'),
              onPressed: () {
                Navigator.pushNamed(context, '/bot');
              },
              color: Colors.lightBlue,
              textColor: Colors.white,
            ),
            FlatButton(
              child: Text('Best Performers'),
              onPressed: () {
                Navigator.pushNamed(context, '/best-performers');
              },
              color: Colors.lightBlue,
              textColor: Colors.white,
            ),
            FlatButton(
              child: Text('Subscribe'),
              onPressed: () {
                Navigator.pushNamed(context, '/subscribe');
              },
              color: Colors.lightBlue,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
