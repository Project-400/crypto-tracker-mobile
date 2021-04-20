import 'dart:async';
import 'dart:convert';

import 'package:crypto_tracker/components/bottom-navigation.dart';
import 'package:crypto_tracker/components/confirm-logout-dialog.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class PriceAlertsScreen extends StatefulWidget {
  PriceAlertsScreen({Key key, this.title}) : super(key: key);

  final String title;
  List<dynamic> alerts = [];

  @override
  _PriceAlertsScreenState createState() => _PriceAlertsScreenState();
}

class _PriceAlertsScreenState extends State<PriceAlertsScreen> {

  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    fetchCurrentAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => showConfirmLogoutDialog(context),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                itemCount: widget.alerts != null ? widget.alerts.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  final dynamic alert = widget.alerts[index];

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
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    alert['symbol'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '\$${alert['price']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '+${alert['percentageDifference']}%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
//                            Text(
//                              '${(stats.pricePercentageChanges['min5']).toStringAsFixed(2)}%',
//                              style: TextStyle(
//                                  fontSize: 16
//                              ),
//                            ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  '+${alert['time']}%',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
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
    super.dispose();
  }

  Future<http.Response> fetchCurrentAlerts() async {
    setState(() {
      isUpdating = true;
    });

    final response = await http.get('http://localhost:3010/v1/price-alerts');

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        widget.alerts = data['priceAlerts'];
      });
    } else {
      throw Exception('Failed to fetch Price Alerts');
    }

    setState(() {
      isUpdating = false;
    });
  }
}
