import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SubscribeScreen extends StatefulWidget {
  SubscribeScreen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {

  Timer ticker;
  bool isUpdating = false;
  bool isBotWorking = false;
  bool showBotDetails = false;
  String selectedCurrencyPair;
  double quoteAmount;
  bool isProfiting = false;
  double priceDifferenceInUSD = 1.89;
  Map<String, dynamic> fullResponse;
  Map<String, dynamic> bot;

  @override
  void initState() {
    super.initState();
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
            if (!isBotWorking) FlatButton(
              child: Text('Start Bot'),
              onPressed: () => selectedCurrencyPair == null ? null : subscribeToBot(),
              color: selectedCurrencyPair == null ? Colors.grey : Colors.lightBlue,
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
//            Visibility(
//              child: SpinKitWave(
//                color: Colors.black,
//                size: 50.0,
//              ),
//              visible: isUpdating,
//            ),
            Visibility (
              child: botDetails(context),
              visible: isBotWorking,
            ),
            botLogs(context)
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
        ),
        Container (
          child: TextField(
            decoration: InputDecoration(
            labelText: 'Quote Quantity',
              hintText: '0.0001'
            ),
            onChanged: (amount) => quoteAmount = double.parse(amount),
          ),
          padding: EdgeInsets.all(10),
        ),
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
                        isBotWorking ? bot['quoteQty'].toString() : '',
                        style: TextStyle(
                            fontSize: 16
                        )
                      ),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                        isBotWorking ? '2.43245325' : '',
                        style: TextStyle(
                            fontSize: 16
                        )
                      ),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
        Row(
          children: [
            profitLossBlock(context)
          ],
        ),
//        Text(fullResponse != null ? fullResponse.toString() : 'Waiting..'),
      ]
    );
  }

  Widget profitLossBlock(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  isProfiting ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 30,
                ),
                Text(
                  '0.0345',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Row(
              children: [
                Text('~ \$$priceDifferenceInUSD')
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Container(
              child: Row(
                children: [
                  Text(
                      'Spent: ${bot['quoteQty']}'
                  ),
                  Text(
                      'Current Value: ${bot['quoteQty'] + 0.1}'
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              padding: EdgeInsets.only(top: 20),
            )
          ],
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget botLogs(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Center(
            child: Text(
                'Logs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Text('TEST1'),
              Text('TEST2'),
              Text('TEST3')
            ],
          ),
        ],
      )
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
//    getUpdatedBotDetails();
    ticker = Timer.periodic(new Duration(seconds: 5), (timer) {
      getUpdatedBotDetails();
    });
  }

  Future<http.Response> subscribeToBot() async {
    setState(() {
      isUpdating = true;
    });

    if (selectedCurrencyPair == null) throw Exception('No currency selected');
    if (quoteAmount == null) throw Exception('Quote amount is missing selected');

    print('Sending request to bot to trade $selectedCurrencyPair with $quoteAmount quote amount');

    final response = await http.get('http://localhost:3000/v1/subscribe?currency=$selectedCurrencyPair&quoteAmount=$quoteAmount');

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
        quoteAmount = null;
      });
    } else {
      throw Exception('Failed to subscribe to Bot');
    }

    setState(() {
      isUpdating = false;
    });

    setIntervalRequest();
  }

  Future<http.Response> unsubscribeToBot() async {
    setState(() {
      isUpdating = true;
    });

    print('Sending request to shutdown bot ${bot['botId']}.');

    final response = await http.get('http://localhost:3000/v1/unsubscribe');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print('*********');
      print(data);
      print('*********');

      if (ticker != null) ticker.cancel();

      setState(() {
        fullResponse = null;
        bot = null;
        showBotDetails = false;
        isBotWorking = false;
        quoteAmount = null;
      });
    } else {
      throw Exception('Failed to unsubscribe from Bot');
    }

    setState(() {
      isUpdating = false;
    });
  }

  Future<http.Response> getUpdatedBotDetails() async {
    setState(() {
      isUpdating = true;
    });

    print('Sending request to bot ${bot['botId']} for latest updates.');

    final response = await http.get('http://localhost:3000/v1/trader-bot?botId=${bot['botId']}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print('*********');
      print(data);
      print('*********');

      setState(() {
        fullResponse = json.decode(response.body);
        bot = fullResponse['bot'];
      });
    } else {
      throw Exception('Failed to retrieve latest Bot updates');
    }

    setState(() {
      isUpdating = false;
    });
  }

}
