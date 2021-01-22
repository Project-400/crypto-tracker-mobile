import 'dart:async';
import 'dart:convert';

//import 'package:crypto_tracker/models/price-change-stats.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubscribeScreen extends StatefulWidget {
  SubscribeScreen({Key key, this.title}) : super(key: key);

  final String title;
//  final List<PriceChangeStats> stats = [];

  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {

  Timer ticker;
  bool isUpdating = false;
  bool isBotWorking = false;
  bool showBotDetails = false;
  Map<String, dynamic> fullResponse;
  Map<String, dynamic> bot;

  @override
  void initState() {
    super.initState();
//    setIntervalRequest();
//    subscribeToBot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
//          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(isUpdating ? 'Updating...' : ''),
            if (!isBotWorking) FlatButton(
              child: Text('Start Bot'),
              onPressed: () {
                subscribeToBot();
              },
              color: Colors.lightBlue,
              textColor: Colors.white,
            ),
            if (isBotWorking) FlatButton(
              child: Text('Shutdown Bot'),
              onPressed: () {
                unsubscribeToBot();
              },
              color: Colors.lightBlue,
              textColor: Colors.white,
            ),
            Visibility (
              child: botDetails(context),
              visible: isBotWorking,
            ),
          ],
        ),
      ),
    );
  }

  Widget botDetails(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            isBotWorking ? bot['tradingPairSymbol'] : '',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        Row(
          children: [
            Expanded(
                child:
                Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          isBotWorking ? '${bot['quote']}' : '',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                            isBotWorking ? '24.54404' : '',
                            style: TextStyle(
                                fontSize: 16
                            )
                        ),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey,
                  ),
                ),
            ),
            Icon(
                Icons.keyboard_arrow_right
            ),
            Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          isBotWorking ? '${bot['base']}' : '',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          isBotWorking ? '24.54404' : '',
                          style: TextStyle(
                              fontSize: 16
                          )
                        ),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 5, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey,
                  ),
                )
            ),
          ],
        ),
        Center(
          child: Text(isBotWorking ? 'The bot is currently ${bot['botState']}' : ''),
        ),
        Center(
          child: Text(isBotWorking ? '1 ${bot['base']} = ${bot['currentPrice']} ${bot['quote']}' : ''),
        ),
        Text(fullResponse != null ? fullResponse.toString() : 'Waiting..'),
      ]
    );
  }

  @override
  void dispose() {
    if (ticker != null) ticker.cancel();
    super.dispose();
  }

  void setIntervalRequest() {
    subscribeToBot();
    ticker = Timer.periodic(new Duration(seconds: 5), (timer) {
      subscribeToBot();
    });
  }

  Future<http.Response> subscribeToBot() async {
    setState(() {
      isUpdating = true;
    });

    final response = await http.get('http://localhost:3000/v1/subscribe');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print('*********');
      print(data);
      print('*********');
//      final stats = (data['stats'] as List).map((s) => PriceChangeStats.fromJson(s));

      setState(() {
//        widget.stats.clear();
//        widget.stats.addAll(stats);
        fullResponse = json.decode(response.body);
        bot = fullResponse['bot'];
        showBotDetails = true;
        isBotWorking = true;

        print(bot);
      });
    } else {
      throw Exception('Failed to subscribe to Bot');
    }

    setState(() {
      isUpdating = false;
    });
  }

  Future<http.Response> unsubscribeToBot() async {
    setState(() {
      isUpdating = true;
    });

    final response = await http.get('http://localhost:3000/v1/unsubscribe');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print('*********');
      print(data);
      print('*********');

      setState(() {
        fullResponse = null;
        bot = null;
        showBotDetails = false;
        isBotWorking = false;
      });
    } else {
      throw Exception('Failed to unsubscribe from Bot');
    }

    setState(() {
      isUpdating = false;
    });
  }

}
