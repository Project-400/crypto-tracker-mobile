import 'dart:async';
import 'dart:convert';

import 'package:crypto_tracker/models/price-change-stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class BestPerformersScreen extends StatefulWidget {
  BestPerformersScreen({Key key, this.title}) : super(key: key);

  final String title;
  final List<PriceChangeStats> stats = [];

  @override
  _BestPerformersScreenState createState() => _BestPerformersScreenState();
}

class _BestPerformersScreenState extends State<BestPerformersScreen> {

  Timer ticker;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    setIntervalRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text('Showing the top 20 best performing assets in the past 5 minutes.'),
              padding: EdgeInsets.all(10),
            ),
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
                itemCount: widget.stats != null ? widget.stats.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  final PriceChangeStats stats = widget.stats[index];

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
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4)
                          )
                      ),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                stats.symbol,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                            ),
                            Text(
                              '${(stats.pricePercentageChanges['min5']).toStringAsFixed(2)}%',
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
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
    ticker.cancel();
    super.dispose();
  }

  void setIntervalRequest() {
    fetchBestPerformers();
    ticker = Timer.periodic(new Duration(seconds: 20), (timer) {
      fetchBestPerformers();
    });
  }

  Future<http.Response> fetchBestPerformers() async {
    setState(() {
      isUpdating = true;
    });

    final response = await http.get('https://w0sizekdyd.execute-api.eu-west-1.amazonaws.com/dev/trends/best-performers');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final stats = (data['stats'] as List).map((s) => PriceChangeStats.fromJson(s));
      
      setState(() {
        widget.stats.clear();
        widget.stats.addAll(stats);
      });
    } else {
      throw Exception('Failed to fetch Best Performers');
    }

    setState(() {
      isUpdating = false;
    });
  }
}
