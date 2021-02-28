import 'dart:convert';

import 'package:crypto_tracker/models/binance-kline-point.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trading_chart/entity/k_line_entity.dart';
import 'package:trading_chart/k_chart_widget.dart';
import 'package:http/http.dart' as http;

class PriceChartsScreen extends StatefulWidget {
  PriceChartsScreen({ Key key, this.title }) : super(key: key);

  final String title;

  @override
  _PriceChartsScreenState createState() => _PriceChartsScreenState();
}

class _PriceChartsScreenState extends State<PriceChartsScreen> {

  List<KLineEntity> datas = [
    KLineEntity.fromJson({
      'open': 10,
      'close': 18,
      'high': 23,
      'low': 8,
      'vol': 23,
      'amount': 23,
      'time': DateTime.now().millisecondsSinceEpoch,
//      'ratio': 23,
//      'change': 23,
    }),
    KLineEntity.fromJson({
      'open': 18,
      'close': 17,
      'high': 21,
      'low': 15,
      'vol': 15,
      'amount': 23,
      'time': DateTime.now().millisecondsSinceEpoch,
//      'ratio': 23,
//      'change': 23,
    }),
    KLineEntity.fromJson({
      'open': 17,
      'close': 21,
      'high': 21,
      'low': 16,
      'vol': 8,
      'amount': 23,
      'time': DateTime.now().millisecondsSinceEpoch,
//      'ratio': 23,
//      'change': 23,
    }),
  ];

  bool isUpdating = false;
  String selectedCurrencyPair = 'BTCUSDT';
  String selectedInterval = '1m';
  bool isLine = false;

  List<KLineEntity> klines = [];
  bool showLoading = true;
  MainState _mainState = MainState.NONE;
  SecondaryState _secondaryState = SecondaryState.NONE;
  bool isChinese = false;

  @override
  void initState() {
    super.initState();

    getKlineData(selectedCurrencyPair, selectedInterval);
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
//        onWillPop: selectedCurrencyPair != null ? () => Future.value(false) : null,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body:
          ListView(
            children: <Widget>[
              intervalButtons(),
              chartTypeButtons(),
              Container(
                child: DropdownSearch<String>(
                  mode: Mode.BOTTOM_SHEET,
                  showSelectedItem: true,
                  items: ['ADAUSDT', 'AAVEUSDT', 'ZRXBTC', 'COTIBTC', 'CELOBTC', 'GTOBTC', 'CRVBTC', 'LTOBTC', 'ALPHABTC', 'SUSHIBTC', 'MANABTC', 'XLMBTC', 'XRPBTC'],
                  label: 'Currency Pair',
                  hint: 'The crypto currency you want to trade',
                  onChanged: (currencyPair) => setSelectedCurrencyPair(currencyPair),
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
                        print('end');
                      },// Called when the data scrolls to the end. When a is true, it means the user is pulled to the end of the right side of the data. When a
                      // is false, it means the user is pulled to the end of the left side of the data.
                      maDayList: [5,10,20],// Display of MA,This parameter must be equal to DataUtil.calculate‘s maDayList
                      bgColor: [Colors.black, Colors.black],// The background color of the chart is gradient
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
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
    print('Set chart type: $isLine');
    setState(() {
//      klines = [];
      this.isLine = isLine;

//      getKlineData(selectedCurrencyPair, selectedInterval);
    });
  }

  Future<http.Response> getKlineData(String pair, String interval) async {
    if (selectedCurrencyPair == null) return null;

    setState(() {
      isUpdating = true;
    });

    print('Sending request to get kline data.');

    final response = await http.get('https://api.binance.com/api/v3/klines?symbol=$pair&interval=$interval');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print('*********');
      print(data);
      print('*********');

      final klinePoints = (data as List<dynamic>).map((d) => BinanceKlinePoint.fromJson(d).toK_Line()).toList();

      setState(() {
        klines = klinePoints.toList();
      });
    } else {
      throw Exception('Failed to gather kline data');
    }

    setState(() {
      isUpdating = false;
    });
  }

}
