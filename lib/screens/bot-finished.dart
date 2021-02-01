import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_tracker/models/coin.dart';

class BotFinishedScreen extends StatefulWidget {
  BotFinishedScreen({Key key, this.title, this.botId, }) : super(key: key);

  final String title;
  final String botId;

  @override
  _BotFinishedScreenState createState() => _BotFinishedScreenState();
}

class _BotFinishedScreenState extends State<BotFinishedScreen> {

  Map<String, dynamic> tradeData;

  @override
  void initState() {
    super.initState();

    getBotTradeData();
  }

  @override
  Widget build(BuildContext context) {
//    final  Map<String, Object> navProps = ModalRoute.of(context).settings.arguments;
//
//    botId = navProps['botId'];
//    getBotTradeData();

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
//              Text('Bot Finished Screen'),
              Container(
                width: 250,
                height: 250,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '+2',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      '+2%',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  Future<http.Response> getBotTradeData() async {
    final response = await http.get('http://localhost:3000/v1/trader-bot/trade-data?botId=${widget.botId}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print('*********');
      print(data);
      print('*********');

      setState(() {
        tradeData = data['tradeData'];
      });
    } else {
      throw Exception('Failed to retrieve bot trade data');
    }
  }
}
