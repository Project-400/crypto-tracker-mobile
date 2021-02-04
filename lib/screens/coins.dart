import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_tracker/models/coin.dart';

class CoinsScreen extends StatefulWidget {
  CoinsScreen({Key key, this.title}) : super(key: key);

  final String title;
  final List<Coin> coins = [];

  @override
  _CoinsScreenState createState() => _CoinsScreenState();
}

class _CoinsScreenState extends State<CoinsScreen> {

  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    fetchCoins();
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
            if (isUpdating) Container(
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
                    'Fetching Coins..',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            if (!isUpdating) Container(
              child: Text('${widget.coins.length} Currencies'),
              padding: EdgeInsets.all(10),
            ),
            if (!isUpdating) Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(10),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.coins != null ? widget.coins.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  final Coin coin = widget.coins[index];

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
                                coin.coin,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                            ),
                            Text(
                              coin.free.toStringAsFixed(6),
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

  Future<void> fetchCoins() async {
    setState(() {
      isUpdating = true;
    });

    final response = await http.get('http://localhost:15002/coins');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print("---------");
      print(data);
      print("---------");

      final coins = (data['coins'] as List).map((c) => Coin.fromJson(c));
      setState(() {
        widget.coins.addAll(coins);
        isUpdating = false;
      });
    } else {
      throw Exception('Failed to fetch Coins');
    }
  }
}
