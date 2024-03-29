import 'dart:convert';

import 'package:crypto_tracker/auth/check-auth.dart';
import 'package:crypto_tracker/components/app-bar.dart';
import 'package:crypto_tracker/components/bottom-navigation.dart';
import 'package:crypto_tracker/components/confirm-logout-dialog.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:crypto_tracker/models/binance-kline-point.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trading_chart/entity/k_line_entity.dart';
import 'package:trading_chart/k_chart_widget.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PriceChartsScreen extends StatefulWidget {
  PriceChartsScreen({ Key key, this.title, this.symbol }) : super(key: key);

  final String title;
  String symbol;
  final WebSocketChannel channel = IOWebSocketChannel.connect('wss://stream.binance.com:9443/ws');

  @override
  _PriceChartsScreenState createState() => _PriceChartsScreenState();
}

class _PriceChartsScreenState extends State<PriceChartsScreen> {
  bool isLoggedIn = false;

  bool isUpdating = false;
  String lastCurrencyPair;
  String selectedCurrencyPair = 'BTCUSDT';
  String subscribedPair;
  String subscribedInterval;
  String selectedInterval = '1m';
  bool isLine = false;
  List<String> symbolList = [];

  List<KLineEntity> klines = [];
  bool showLoading = true;
  MainState _mainState = MainState.NONE;
  SecondaryState _secondaryState = SecondaryState.NONE;
  bool isChinese = false;

  @override
  void initState() {
    super.initState();

    if (widget.symbol != null) selectedCurrencyPair = widget.symbol;

    widget.channel.stream.listen((received) {
      _receivePriceUpdate(received);
    });

    getKlineData(selectedCurrencyPair, selectedInterval);
    getSymbolList();
  }

  @override
  Widget build(BuildContext context) {
    checkIfAuthenticated().then((success) {
      setState(() {
        isLoggedIn = success;
      });
    });

    return
      WillPopScope(
//        onWillPop: selectedCurrencyPair != null ? () => Future.value(false) : null,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
            ),
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
          bottomNavigationBar: BottomNavBar(selectedScreen: ScreenTitles.PRICE_CHARTS),
          body:
          ListView(
            children: <Widget>[
              intervalButtons(),
              chartTypeButtons(),
              Container(
                child: DropdownSearch<String>(
                  mode: Mode.BOTTOM_SHEET,
                  showSelectedItem: true,
                  items: symbolList,
                  label: 'Currency Pair',
                  hint: 'The crypto currency you want to trade',
                  onChanged: (currencyPair) => setSelectedCurrencyPair(currencyPair),
                  selectedItem: selectedCurrencyPair,
                ),
                padding: EdgeInsets.all(10),
              ),
              Container(
                height: 600,
//                width: double.infinity,
                child: Stack(
                  children: [
                    KChartWidget(
                      klines,// Required，Data must be an ordered list，(history=>now)
                      isLine: isLine,// Decide whether it is k-line or time-sharing
                      mainState: _mainState,// Decide what the main view shows
                      secondaryState: _secondaryState,// Decide what the sub view shows
                      fixedLength: 8,// Displayed decimal precision
                      timeFormat: TimeFormat.YEAR_MONTH_DAY_WITH_HOUR ,
                      onLoadMore: (bool a) {
                        print(a); // a = true is the end on the right, a = false is the end on the left
                        print('end');
                      },// Called when the data scrolls to the end. When a is true, it means the user is pulled to the end of the right side of the data. When a
                      // is false, it means the user is pulled to the end of the left side of the data.
                      maDayList: [5,10,20],// Display of MA,This parameter must be equal to DataUtil.calculate‘s maDayList
                      bgColor: [Color(0xff22292e), Color(0xff22292e)],// The background color of the chart is gradient
                      isChinese: false,// Graphic language
                      isOnDrag: (isDrag){
                        print('drag');
                      },// true is on Drag.Don't load data while Dragging.
                    ),
                    if (isUpdating) Container(
                      child: SpinKitWave(
                        color: Colors.blue,
                        size: 60,
                      ),
//                      margin: EdgeInsets.symmetric(vertical: 200),
                    ),
                  ],
                ),
              ),
            ]
          ),
        ),
      );
  }

  Widget intervalButton(String text, Function onPressed) {
    return Container(
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16
          ),
        ),
        onPressed: selectedInterval == text ? null : onPressed,
        color: Colors.lightBlue,
        textColor: Colors.white,
        disabledColor: Colors.grey,
      ),
      width: double.infinity,
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
    );
  }

  Widget chartTypeButton(String text, bool isLine) {
    return Container(
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16
          ),
        ),
        onPressed: this.isLine == isLine ? null : () => setChartType(isLine),
        color: Colors.lightBlue,
        textColor: Colors.white,
        disabledColor: Colors.grey,
      ),
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 2, left: 4, right: 4),
    );
  }

  Widget intervalButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: intervalButton('1m', () => setInterval('1m'))
        ),
        Expanded(
            child: intervalButton('1h', () => setInterval('1h'))
        ),
        Expanded(
            child: intervalButton('1d', () => setInterval('1d'))
        ),
        Expanded(
            child: intervalButton('1w', () => setInterval('1w'))
        ),
        Expanded(
            child: intervalButton('1M', () => setInterval('1M'))
        ),
      ],
    );
  }

  Widget chartTypeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: chartTypeButton('KLine', false)
        ),
        Expanded(
            child: chartTypeButton('Line', true)
        )
      ],
    );
  }

  void setSelectedCurrencyPair(String pair) {
    setState(() {
      klines = [];
      lastCurrencyPair = selectedCurrencyPair;
      selectedCurrencyPair = pair;

      getKlineData(selectedCurrencyPair, selectedInterval);
    });
  }

  void setInterval(String interval) {
    setState(() {
      klines = [];
      selectedInterval = interval;

      getKlineData(selectedCurrencyPair, selectedInterval);
    });
  }

  void setChartType(bool isLine) {
    setState(() {
      this.isLine = isLine;
    });
  }

  Future<bool> getStoredPairsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String allSymbols = prefs.getString('allSymbols');

    if (allSymbols != null) {
      List<String> symbols = json.decode(allSymbols).cast<String>();

      setState(() {
        symbolList = symbols;
      });

      return true;
    }

    return false;
  }

  void setStoredPairsList(List<String> symbols) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('allSymbols', json.encode(symbols));
  }

  Future<void> getSymbolList() async {
    await getStoredPairsList(); // Continue to request symbols in case a change has been made since last local storage save

    final response = await http.get('http://localhost:15003/exchange-info/valid-symbols');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        if (data['symbols'] != null) symbolList = data['symbols'].cast<String>();
        setStoredPairsList(symbolList);
      });
    } else {
      throw Exception('Failed to gather symbol list');
    }
  }

  Future<void> getKlineData(String pair, String interval) async {
    if (selectedCurrencyPair == null) return null;

    setState(() {
      isUpdating = true;
    });

    final response = await http.get('https://api.binance.com/api/v3/klines?symbol=$pair&interval=$interval');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final klinePoints = (data as List<dynamic>).map((d) => BinanceKlinePoint.fromBinanceHttp(d).toK_Line()).toList();

      setState(() {
        klines = klinePoints.toList();
      });

      Future.delayed(const Duration(seconds: 1), () => {
        _subscribeToSymbolPrice(selectedCurrencyPair, selectedInterval)
      });
    } else {
      throw Exception('Failed to gather kline data');
    }

    setState(() {
      isUpdating = false;
    });
  }

  void _receivePriceUpdate(String message) {
    try {
      Map<String, dynamic> data = json.decode(message);

      if (data['e'] != null && data['e'] == 'kline' && data['s'] != null && data['s'] == selectedCurrencyPair && data['k']['i'] == selectedInterval) {
        KLineEntity kline = BinanceKlinePoint.fromBinanceWs(data['k']).toK_Line();

        setState(() {
          if (kline.time == klines.last.time) klines.last = kline;
          else klines.add(kline);
        });
      }
    } catch (e) {
      print(e);
      print('Websocket message is not in JSON format');
    }
  }

  void _subscribeToSymbolPrice(String symbol, String interval) {
    if (lastCurrencyPair != null) {
      print('UNSUB from ${lastCurrencyPair.toLowerCase()}@kline_$subscribedInterval');
      widget.channel.sink.add('{ "method": "UNSUBSCRIBE", "params": [ "${lastCurrencyPair.toLowerCase()}@kline_$subscribedInterval" ], "id": 1 }');
    }
    print('SUB to ${symbol.toLowerCase()}@kline_$interval');
    widget.channel.sink.add('{ "method": "SUBSCRIBE", "params": [ "${symbol.toLowerCase()}@kline_$interval" ], "id": 1 }');

    setState(() {
      subscribedPair = symbol;
      subscribedInterval = interval;
    });
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

}
