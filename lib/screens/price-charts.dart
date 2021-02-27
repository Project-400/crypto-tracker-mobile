import 'dart:convert';

import 'package:crypto_tracker/models/binance-kline-point.dart';
import 'package:flutter/material.dart';
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

  List<KLineEntity> klines = [];

  bool isUpdating = false;
  bool showLoading = true;
  MainState _mainState = MainState.NONE;
  SecondaryState _secondaryState = SecondaryState.NONE;
  bool isLine = false;
  bool isChinese = true;

  @override
  void initState() {
    super.initState();

    getKlineData();
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child:
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Price Charts'),
                  Container(
                    height: 600,
                    width: double.infinity,
                    child: KChartWidget(
                      klines,// Required，Data must be an ordered list，(history=>now)
                      isLine: isLine,// Decide whether it is k-line or time-sharing
                      mainState: _mainState,// Decide what the main view shows
                      secondaryState: _secondaryState,// Decide what the sub view shows
                      fixedLength: 2,// Displayed decimal precision
                      timeFormat: TimeFormat.YEAR_MONTH_DAY,
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
                  ),
                ]
            ),
          ),
        ),
      );
  }

  Future<http.Response> getKlineData() async {
    setState(() {
      isUpdating = true;
    });

    print('Sending request to get kline data.');

    final response = await http.get('https://api.binance.com/api/v3/klines?symbol=ADAUSDT&interval=1m');

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
