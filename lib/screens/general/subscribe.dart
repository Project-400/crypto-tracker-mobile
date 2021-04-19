import 'dart:async';
import 'dart:convert';

import 'package:crypto_tracker/auth/check-auth.dart';
import 'package:crypto_tracker/components/bottom-navigation.dart';
import 'package:crypto_tracker/components/confirm-logout-dialog.dart';
import 'package:crypto_tracker/constants/enums.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:crypto_tracker/models/bot-log.dart';
import 'package:crypto_tracker/screens/general/bot-finished.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class SubscribeScreen extends StatefulWidget {
  SubscribeScreen({Key key, this.title}) : super(key: key);

  final String title;
  final WebSocketChannel channel = IOWebSocketChannel.connect('ws://localhost:8999');

  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  bool isLoggedIn = false;

//  Timer ticker;
  Timer timer;
  Timer priceCheckTimer;
  bool isUpdating = false;
  bool isBotWorking = false;
  bool showBotDetails = false;
  String selectedCurrencyPair;
  String clientSocketId;
  double quoteAmount;
  double percentageLoss;
  bool repeatedlyTrade = false;
  bool isProfiting = false;
  double priceDifferenceInUSD = 0;
  Map<String, dynamic> fullResponse;
  Map<String, dynamic> bot;
  Map<String, dynamic> priceInfo;
  Map<String, dynamic> tradeData;
  String currentPrice;
  List<BotLog> botLogEvents = [];
  List<BotLog> botPrepEvents = [];
  BotState botState = BotState.NONE;
  int secondsTrading = 0;
  double BTCPrice = 0;

  @override
  void initState() {
    super.initState();

    widget.channel.stream.listen((received) {
      _receiveBotUpdate(received);
    });
  }

  @override
  Widget build(BuildContext context) {
    checkIfAuthenticated().then((success) {
      setState(() {
        isLoggedIn = success;
      });
    });

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            automaticallyImplyLeading: false,
            actions: [
              if (isLoggedIn) Padding(
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () => showConfirmLogoutDialog(context),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(selectedScreen: ScreenTitles.SUBSCRIBE),
          body: Center(
              child: ListView(
                children: <Widget>[
                  Visibility (
                    child: currencyPairSelector(context),
                    visible: !isBotWorking && !isUpdating,
                  ),
                  if (!isBotWorking && !isUpdating) botButton(
                      'Start Bot',
                          () => selectedCurrencyPair == null || quoteAmount == null ? null : subscribeToBot()
                  ),
                  if (isBotWorking && !isUpdating) Row(
                    children: [
                      Expanded(
                        child: botButton(
                            'Shutdown Bot',
                                () => unsubscribeToBot()
                        ),
                      ),
                      Expanded(
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
//                        shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Icon(
                                    Icons.access_time,
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                      child: Text(
                                          secondsTrading.toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                    )
                                ),
                              ],
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
//                      color: Colors.grey,
                            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                          )
                      ),
                    ],
//              mainAxisAlignment: MainAxisAlignment.center
                  ),
                  if (isBotWorking) Container(
                      child: Divider(
                        color: Color(0xffcccccc),
                        height: 1,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                      margin: EdgeInsets.only(bottom: 15)
                  ),
                  if (isBotWorking) Container(
                    child: SpinKitPulse(
                      color: Colors.blue,
                      size: 30,
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  Visibility (
                    child: botDetails(context),
                    visible: isBotWorking,
                  ),
                  if (isBotWorking) Container(
                      child: Divider(
                        color: Color(0xffcccccc),
                        height: 1,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                      margin: EdgeInsets.only(top: 15)
                  ),
                  Visibility (
                    child: botLogs(context),
                    visible: isBotWorking,
                  ),
                  Visibility(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            child: SpinKitWave(
                              color: Colors.blue,
                              size: 60,
                            ),
                            margin: EdgeInsets.symmetric(vertical: 50),
                          ),
                          Text(
                            'Preparing Bot..',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            child: SvgPicture.asset(
                              'assets/bot.svg',
                              semanticsLabel: 'Preparing Bot',
                              placeholderBuilder: (BuildContext context) => Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child: const CircularProgressIndicator()
                              ),
                              height: 300,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 80, horizontal: 10),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
//                height: 700, // TODO: Temporarily hard coded
                    ),
                    visible: isUpdating && !isBotWorking,
                  ),
                ],
              )
          ),
        )
    );
  }

  Widget botButton(String text, Function onPressed) {
    return Container(
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16
          ),
        ),
        onPressed: onPressed,
        color: isBotWorking ? Colors.red : Colors.lightBlue,
        textColor: Colors.white,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
  }

  Widget currencyPairSelector(BuildContext context) {
    return Column(
      children: [
        Container(
          child: DropdownSearch<String>(
            mode: Mode.BOTTOM_SHEET,
            showSelectedItem: true,
            items: ['ZRXBTC', 'COTIBTC', 'CELOBTC', 'GTOBTC', 'CRVBTC', 'LTOBTC', 'ALPHABTC', 'SUSHIBTC', 'MANABTC', 'XLMBTC', 'XRPBTC'],
            label: 'Currency Pair',
            hint: 'The crypto currency you want to trade',
            onChanged: (currencyPair) => setSelectedCurrencyPair(currencyPair),
          ),
          padding: EdgeInsets.all(10),
        ),
        Container(
          child: TextField(
            decoration: InputDecoration(
            labelText: 'Quote Quantity',
              hintText: '0.0001'
            ),
            onChanged: (amount) => quoteAmount = double.parse(amount),
          ),
          padding: EdgeInsets.all(10),
        ),
        Container(
          child: TextField(
            decoration: InputDecoration(
            labelText: 'Max Percentage Loss (Default 1%)',
              hintText: '1'
            ),
            onChanged: (amount) => percentageLoss = double.parse(amount),
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
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
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
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
        Center(
          child: Container(
            child: Text(isBotWorking ? 'The bot is currently ${botState.toString().split('.').last}' : ''),
            margin: EdgeInsets.symmetric(vertical: 20),
          )
        ),
        Center(
          child: Container(
            child: Text(isBotWorking ? '1 ${bot['base']} = $currentPrice ${bot['quote']}' : ''),
            margin: EdgeInsets.only(bottom: 10),
          ),
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
//        Text(botState.toString().split('.').last),
      ]
    );
  }

  Widget profitLossBlock(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Container(
              child: Text(
                'Profit / Loss',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              ),
              margin: EdgeInsets.only(bottom: 20),
            ),
            Row(
              children: [
//                Icon(
//                  isProfiting ? Icons.arrow_upward : Icons.arrow_downward,
//                  size: 30,
//                ),
                if (tradeData != null && tradeData['percentageDifference'] >= 0) Text('+',
                  style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  tradeData != null ? '${(double.parse(tradeData['priceDifference']) * tradeData['baseQty']).toStringAsFixed(tradeData['baseAssetPrecision'])} BTC' : '',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Text(
              tradeData != null ? '(${tradeData['percentageDifference'].toStringAsFixed(2)}%)' : '',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            if (tradeData != null) Row(
              children: [
                Container(
                  child: Text(
                      '~ \$${(BTCPrice * double.parse(tradeData['priceDifference']) * tradeData['baseQty']).toStringAsFixed(4)}',
                    style: TextStyle(
                        fontSize: 16,
                    ),
                  ),
                  margin: EdgeInsets.only(top: 20)
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
//            Container(
//              child: Row(
//                children: [
//                  Text(
//                      'Spent: ${isBotWorking ? bot['quoteQty'] : '0'}'
//                  ),
//                  Text(
//                      'Current Value: ${isBotWorking ? bot['quoteQty'] + 0.1 : 0}'
//                  )
//                ],
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              ),
//              padding: EdgeInsets.only(top: 20),
//            )
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }

  Widget botLogs(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            child: Text(
              'Logs',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
            padding: EdgeInsets.only(top: 20),
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
//                  color: Colors.grey,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
//                      boxShadow: [
//                        BoxShadow(
//                          color: Colors.grey.withOpacity(0.3),
//                          spreadRadius: 0.2,
//                          blurRadius: 0.5,
//                          offset: Offset(0, 0.5), // changes position of shadow
//                        ),
//                      ],
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Color(0xffdddddd),
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
                                '${DateFormat.Hms().format(log.time)}',
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
//    if (ticker != null) ticker.cancel();
    if (timer != null) timer.cancel();
    if (priceCheckTimer != null) priceCheckTimer.cancel();
    widget.channel.sink.close();
    super.dispose();
  }

//  void setIntervalRequest() {
////    getUpdatedBotDetails();
//    ticker = Timer.periodic(new Duration(seconds: 5), (timer) {
//      getUpdatedBotDetails();
//    });
//  }

  void timerCount() {
    timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        secondsTrading = secondsTrading + 1;
      });
    });
  }

  void priceChecker() {
    priceCheckTimer = Timer.periodic(new Duration(seconds: 10), (timer) {
      getBTCPrice();
    });
  }

  Future<http.Response> subscribeToBot() async {
    setState(() {
      isUpdating = true;
    });

    if (selectedCurrencyPair == null) throw Exception('No currency selected');
    if (quoteAmount == null) throw Exception('Quote amount is missing selected');

    print('Sending request to bot to trade $selectedCurrencyPair with $quoteAmount quote amount');

    final response = await http.get('http://localhost:3000/v1/subscribe?currency=$selectedCurrencyPair&quoteAmount=$quoteAmount&repeatedlyTrade=$repeatedlyTrade&clientSocketId=$clientSocketId&percentageLoss=$percentageLoss');

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

    timerCount();
    priceChecker();
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

//      if (ticker != null) ticker.cancel();

      String botId = bot['botId'];

      setState(() {
        fullResponse = null;
        bot = null;
        showBotDetails = false;
        isBotWorking = false;
        quoteAmount = null;
      });

//      Future.delayed(const Duration(seconds: 3), () {
//        Navigator.push(context, MaterialPageRoute(builder: (context) => BotFinishedScreen(title: 'Bot Finished', botId: botId)));
//      });
    } else {
      throw Exception('Failed to unsubscribe from Bot');
    }

    setState(() {
      isUpdating = false;
    });
  }

//  Future<http.Response> getUpdatedBotDetails() async {
//    setState(() {
//      isUpdating = true;
//    });
//
//    print('Sending request to bot ${bot['botId']} for latest updates.');
//
//    final response = await http.get('http://localhost:3000/v1/trader-bot?botId=${bot['botId']}');
//
//    if (response.statusCode == 200) {
//      final data = json.decode(response.body);
//
//      print('*********');
//      print(data);
//      print('*********');
//
//      setState(() {
//        fullResponse = json.decode(response.body);
//        bot = fullResponse['bot'];
//      });
//    } else {
//      throw Exception('Failed to retrieve latest Bot updates');
//    }
//
//    setState(() {
//      isUpdating = false;
//    });
//  }

  Future<http.Response> getBTCPrice() async {
    print('Sending request to Binance to get BTC price.');

    final response = await http.get('https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print('*********');
      print(data);
      print('*********');

      setState(() {
        BTCPrice = double.parse(data['price']);
      });
    } else {
      throw Exception('Failed to retrieve BTC price from Binance');
    }
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

          if (botState == BotState.FINISHED) {
            Future.delayed(const Duration(seconds: 5), () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BotFinishedScreen(title: 'Bot Finished', botId: bot['botId'])));
            });
          }
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

          isProfiting = double.parse(tradeData['priceDifference']) < 0;
        }
      } catch (e) {
        print('Websocket message is not in JSON format');
      }
    });
  }

}
