import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
              Container(
                child: Row(
                  children: [
                    Text(
                      'Trading has finished. Here is the bot\'s ',
                      style: TextStyle(
                          fontSize: 15
                      ),
                    ),
                    if (double.parse(tradeData['priceDifference']) >= 0) Text(
                      'profit:',
                      style: TextStyle(
                          fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    if (double.parse(tradeData['priceDifference']) < 0) Text(
                      'loss:',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                    mainAxisAlignment: MainAxisAlignment.center
                ),
                margin: EdgeInsets.only(bottom: 20),
              ),
              Container(
                width: 300,
                height: 300,
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
//                    Row(
//                      children: [
//                        Text(
//                          '${tradeData['priceDifference']}',
//                          style: TextStyle(
//                              fontSize: 40,
//                              fontWeight: FontWeight.bold
//                          ),
//                        ),
//                        Text(
//                          ' ${tradeData['base']}',
//                          style: TextStyle(
//                              fontSize: 30,
//                              fontWeight: FontWeight.bold
//                          ),
//                        ),
//                      ],
//                      mainAxisAlignment: MainAxisAlignment.center,
//                    ),
                    Row(
                      children: [
                        if (double.parse(tradeData['priceDifference']) >= 0) Text(
                          '+',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '${double.parse(tradeData['priceDifference']) * tradeData['staticBaseQty']}',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center
                    ),
                    Text(
                      ' ${tradeData['quote']}',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      ),
                    ),
//                    Text(
//                      '${tradeData['percentageDifference'].toStringAsFixed(2)}%',
//                      style: TextStyle(
//                          fontSize: 26,
//                          fontWeight: FontWeight.bold
//                      ),
//                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              Container(
                child: RaisedButton(
                  child: Text(
                    'Done',
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  color: Colors.lightBlue,
                  textColor: Colors.white,
                ),
                width: double.infinity,
                margin: EdgeInsets.only(top: 50),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              )
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
