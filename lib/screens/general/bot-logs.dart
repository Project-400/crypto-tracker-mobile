import 'dart:async';
import 'dart:convert';

import 'package:crypto_tracker/components/bottom-navigation.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:crypto_tracker/models/price-change-stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class BotLogsScreen extends StatefulWidget {
  BotLogsScreen({Key key, this.title}) : super(key: key);

  final String title;
  List<dynamic> bots = [];

  @override
  _BotLogsScreenState createState() => _BotLogsScreenState();
}

class _BotLogsScreenState extends State<BotLogsScreen> {

  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    fetchBotLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavBar(selectedScreen: ScreenTitles.BEST_PERFORMERS),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//            Container(
//              child: Text('Bot'),
//              padding: EdgeInsets.all(10),
//            ),
            if (isUpdating) Container(
              child: SpinKitWave(
                color: Colors.blue,
                size: 40,
              ),
              margin: EdgeInsets.symmetric(vertical: 20),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(10),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.bots != null ? widget.bots.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  final dynamic bot = widget.bots[index];

                  return Text(
                      bot.toString()
                  );
//                  return InkWell(
//                    child: Container(
//                      padding: EdgeInsets.all(10),
//                      decoration: BoxDecoration(
//                          boxShadow: [
//                            BoxShadow(
//                              color: Colors.grey.withOpacity(0.3),
//                              spreadRadius: 0.2,
//                              blurRadius: 0.5,
//                              offset: Offset(0, 0.5), // changes position of shadow
//                            ),
//                          ],
//                          borderRadius: BorderRadius.only(
//                              topLeft: Radius.circular(4),
//                              topRight: Radius.circular(4),
//                              bottomLeft: Radius.circular(4),
//                              bottomRight: Radius.circular(4)
//                          )
//                      ),
//                      child: Center(
//                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Container(
//                              child: Text(
//                                stats.symbol,
//                                style: TextStyle(
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 16
//                                ),
//                              ),
//                            ),
//                            Text(
//                              '${(stats.pricePercentageChanges['min5']).toStringAsFixed(2)}%',
//                              style: TextStyle(
//                                  fontSize: 16
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
//    ticker.cancel();
    super.dispose();
  }

//  void setIntervalRequest() {
//    fetchBotLogs();
//    ticker = Timer.periodic(new Duration(seconds: 20), (timer) {
//      fetchBestPerformers();
//    });
//  }

  Future<http.Response> fetchBotLogs() async {
    setState(() {
      isUpdating = true;
    });

    final response = await http.get('http://localhost:15003/trader-bot/user/fakeuserid350350/10');

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        widget.bots = data['bots'];
      });
    } else {
      throw Exception('Failed to fetch Bot Logs');
    }

    setState(() {
      isUpdating = false;
    });
  }
}
