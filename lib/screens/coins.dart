import 'package:flutter/material.dart';

class CoinsScreen extends StatefulWidget {
  CoinsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CoinsScreenState createState() => _CoinsScreenState();
}

class _CoinsScreenState extends State<CoinsScreen> {
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
            Text('My Coins'),
          ],
        ),
      ),
    );
  }
}
