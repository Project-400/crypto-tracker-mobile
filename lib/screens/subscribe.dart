import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:crypto_tracker/constants/enums.dart';
import 'package:crypto_tracker/models/bot-log.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:enum_to_string/enum_to_string.dart';

class SubscribeScreen extends StatefulWidget {
  SubscribeScreen({Key key, this.title}) : super(key: key);

  final String title;
  final WebSocketChannel channel = IOWebSocketChannel.connect('ws://localhost:8999');

  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {

  Timer ticker;
  bool isUpdating = false;
  bool isBotWorking = false;
  bool showBotDetails = false;
  String selectedCurrencyPair;
  String clientSocketId;
  double quoteAmount;
  bool repeatedlyTrade = false;
  bool isProfiting = false;
  double priceDifferenceInUSD = 1.89;
  Map<String, dynamic> fullResponse;
  Map<String, dynamic> bot;
  Map<String, dynamic> priceInfo;
  Map<String, dynamic> tradeData;
  String currentPrice;
  List<BotLog> botLogEvents = [];
  BotState botState = BotState.NONE;

  @override
  void initState() {
    super.initState();

    widget.channel.stream.listen((received) {
      _receiveBotUpdate(received);
    });
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
            Visibility (
              child: botLogs(context),
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
            items: ['CELOBTC', 'GTOBTC', 'CRVBTC', 'LTOBTC', 'ALPHABTC', 'SUSHIBTC', 'MANABTC', 'XLMBTC', 'XRPBTC'],
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
        CheckboxListTile(
          title: Text('Repeatedly Trade'),
          value: repeatedlyTrade,
          onChanged: (isTicked) {
            setState(() {
              repeatedlyTrade = isTicked;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
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
                        isBotWorking && tradeData != null ? tradeData['baseQty'].toString() : '',
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
          child: Text(isBotWorking ? 'The bot is currently $botState' : ''),
        ),
        Center(
          child: Text(isBotWorking ? '1 ${bot['base']} = $currentPrice ${bot['quote']}' : ''),
        ),
//        Center(
//          child: Text(isBotWorking ? '$currentPrice' : ''),
//        ),
        Row(
          children: [
            profitLossBlock(context)
          ],
        ),
//        Text(fullResponse != null ? fullResponse.toString() : 'Waiting..'),
        Text(botState.toString().split('.').last),
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
                  tradeData != null ? '${tradeData['priceDifference']} (${tradeData['percentageDifference'].toStringAsFixed(2)}%)' : '',
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
                      'Spent: ${isBotWorking ? bot['quoteQty'] : '0'}'
                  ),
                  Text(
                      'Current Value: ${isBotWorking ? bot['quoteQty'] + 0.1 : 0}'
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
    return Column(
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
          ListView.separated(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: botLogEvents.length,
              itemBuilder: (BuildContext context, int index) {
                final BotLog log = botLogEvents[index];

                return InkWell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 0.2,
                            blurRadius: 0.5,
                            offset: Offset(0, 0.5), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(4))
                    ),
                    child:
                      Container(
                          child: Row(
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  log.log
                                ),
                              ),
                              Align(
                                child: Text(
                                  '${log.time.hour}:${log.time.minute}:${log.time.second}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12
                                  ),
                                ),
                                alignment: FractionalOffset.bottomCenter,
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          )
                      ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 6,
              ),
            ),

        ],
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
    widget.channel.sink.close();
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

    final response = await http.get('http://localhost:3000/v1/subscribe?currency=$selectedCurrencyPair&quoteAmount=$quoteAmount&repeatedlyTrade=$repeatedlyTrade&clientSocketId=$clientSocketId');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print('*********');
      print(data);
      print('*********');

      setState(() {
        fullResponse = json.decode(response.body);
        bot = fullResponse['bot'];
        priceInfo = fullResponse['priceInfo'];
        currentPrice = priceInfo['price'];
        showBotDetails = true;
        isBotWorking = true;
        selectedCurrencyPair = null;
        repeatedlyTrade = true;
        botState = EnumToString.fromString(BotState.values, bot['botState']);
//        quoteAmount = null;
      });
    } else {
      throw Exception('Failed to subscribe to Bot');
    }

    setState(() {
      isUpdating = false;
    });

//    setIntervalRequest();
  }

  Future<http.Response> unsubscribeToBot() async {
    setState(() {
      isUpdating = true;
    });

    print('Sending request to shutdown bot ${bot['botId']}.');

    final response = await http.get('http://localhost:3000/v1/unsubscribe?botId=${bot['botId']}');

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

  void _receiveBotUpdate(String message) {
    print(message);

    setState(() {
      try {
        final data = json.decode(message);

        if (data['botLog'] != null) {
          BotLog log = BotLog.fromJson(json.decode(data['botLog']));
          botLogEvents.insert(0, log);
          if (botLogEvents.length > 50) botLogEvents.removeLast();
        }
        if (data['botState'] != null) {
          if (data['botId'] == bot['botId']) botState = EnumToString.fromString(BotState.values, data['botState']);
        }
        if (data['clientSocketId'] != null) {
          clientSocketId = data['clientSocketId'].toString();
          print('clientSocketId: $clientSocketId');
        }
        if (data['price'] != null) {
          currentPrice = data['price'].toString();
        }
        if (data['tradeData'] != null) {
          tradeData = data['tradeData'];

          isProfiting = tradeData['priceDifference'] < 0;
        }
      } catch (e) {
        print('Websocket message is not in JSON format');
      }
    });
  }

}
