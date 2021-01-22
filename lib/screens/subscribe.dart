import 'dart:async';
import 'dart:convert';

//import 'package:crypto_tracker/models/price-change-stats.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';

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
  String selectedCurrencyPair;
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
            Visibility (
              child: currencyPairSelector(context),
              visible: !isBotWorking,
            ),
            if (!isBotWorking && selectedCurrencyPair != null) FlatButton(
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

  Widget currencyPairSelector(BuildContext context) {
    return Column(
      children: [
        Container(
          child: DropdownSearch<String>(
            mode: Mode.BOTTOM_SHEET,
            showSelectedItem: true,
            items: ['GTOBTC', 'CRVBTC', 'LTOBTC', 'ALPHABTC', 'SUSHIBTC', 'MANABTC', 'XLMBTC', 'XRPBTC'],
            label: 'Currency Pair',
            hint: 'The crypto currency you want to trade',
            onChanged: (currencyPair) => setSelectedCurrencyPair(currencyPair),
          ),
          padding: EdgeInsets.all(10),
        )
      ],
    );
  }

  Widget botDetails(BuildContext context) {
    return Column(
      children: <Widget>[
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
                Icons.keyboard_arrow_right,
                size: 40,
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

  void setSelectedCurrencyPair(String pair) {
    setState(() {
      selectedCurrencyPair = pair;
    });
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

    if (selectedCurrencyPair == null) throw Exception('No currency selected');

    final response = await http.get('http://localhost:3000/v1/subscribe?currency=$selectedCurrencyPair');

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
        selectedCurrencyPair = null;

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
        selectedCurrencyPair = null;
      });
    } else {
      throw Exception('Failed to unsubscribe from Bot');
    }

    setState(() {
      isUpdating = false;
    });
  }

}
