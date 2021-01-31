import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_tracker/models/coin.dart';

class BotFinishedScreen extends StatefulWidget {
  BotFinishedScreen({Key key, this.title}) : super(key: key);

  final String title;
  final List<Coin> coins = [];

  @override
  _BotFinishedScreenState createState() => _BotFinishedScreenState();
}

class _BotFinishedScreenState extends State<BotFinishedScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
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
              Text('Bot Finished Screen'),
            ]
          ),
        ),
      ),
    );
  }

//  Future<http.Response> fetchCoins() async {
//    final response = await http.get('https://w0sizekdyd.execute-api.eu-west-1.amazonaws.com/dev/coins');
//
//    if (response.statusCode == 200) {
//      final data = json.decode(response.body);
//      final coins = (data['coins'] as List).map((c) => Coin.fromJson(c));
//      setState(() {
//        widget.coins.addAll(coins);
//      });
//    } else {
//      throw Exception('Failed to fetch Coins');
//    }
//  }
}
