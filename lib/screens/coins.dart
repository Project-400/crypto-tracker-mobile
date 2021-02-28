import 'dart:convert';

import 'package:crypto_tracker/models/coins-valuation.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_tracker/models/coin.dart';
import '../models/wallet-valuation.dart';

class CoinsScreen extends StatefulWidget {
  CoinsScreen({Key key, this.title}) : super(key: key);

  final String title;
//  final List<Coin> coins = [];

  @override
  _CoinsScreenState createState() => _CoinsScreenState();
}

class _CoinsScreenState extends State<CoinsScreen> {

  bool isUpdating = false;
  WalletValuation walletValuation;

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
//              child: Text('${widget.coins.length} Currencies'),
              child: Column(
                children: [
                  Text('${walletValuation.values.length} Currencies'),
                  Text('\$${walletValuation.totalValue}')
                ],
              ),
              padding: EdgeInsets.all(10),
            ),
            if (!isUpdating) Container(
              child: DropdownSearch<String>(
                mode: Mode.BOTTOM_SHEET,
                showSelectedItem: true,
                items: [ 'Value - ASC', 'Value - DESC', 'Coin Count - ASC', 'Coin Count - DESC', 'Alphabetically - ASC', 'Alphabetically - DESC' ],
                label: 'Sort By',
                hint: 'The crypto currency you want to trade',
                onChanged: (sortOption) => setSortOption(sortOption),
                selectedItem: 'Value - DESC',
              ),
              padding: EdgeInsets.all(10),
            ),
            if (!isUpdating) Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(10),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: walletValuation.values != null ? walletValuation.values.length : 0,
                itemBuilder: (BuildContext context, int index) {
//                  final Coin coin = widget.coins[index];
                  final coinsValuation = walletValuation.values[index];
                  print(coinsValuation['coin']);

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
                      child: Column(
                        children: [
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    coinsValuation['coin'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                                Text(
                                  coinsValuation['coinCount'].toStringAsFixed(8),
                                  style: TextStyle(
                                      fontSize: 16
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                coinsValuation['usdValue'] != null ? '\$${double.parse(coinsValuation['usdValue']).toStringAsFixed(2)}' : '\$0.00',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
//                                Text(
//                                  coinsValuation['coinCount'].toStringAsFixed(6),
//                                  style: TextStyle(
//                                      fontSize: 16
//                                  ),
//                                ),
                              ],
                            ),
                          ),
                        ],
                      )
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

  void setSortOption(String sortOption) {
    setState(() {
      if (sortOption == 'Value - ASC') walletValuation.sortByValue(false);
      if (sortOption == 'Value - DESC') walletValuation.sortByValue(true);
      if (sortOption == 'Coin Count - ASC') walletValuation.sortByCoinCount(false);
      if (sortOption == 'Coin Count - DESC') walletValuation.sortByCoinCount(true);
      if (sortOption == 'Alphabetically - ASC') walletValuation.sortAlphabetically(false);
      if (sortOption == 'Alphabetically - DESC') walletValuation.sortAlphabetically(true);
    });
  }

  Future<void> fetchCoins() async {
    setState(() {
      isUpdating = true;
    });

    final response = await http.get('http://localhost:15002/valuation/all');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print(data);
      print('----------');

      if (data['success']) {
        setState(() {
//          walletValuation = WalletValuation(data['totalValue'], data['values'].map((Map<String, dynamic> v) =>
//            CoinsValuation(v['coin'], v['coinCount'], v['isNonMainstream'], v['usdValue'], CoinIndividualValues.fromJson(v['individualValues']), CoinTotalValues.fromJson(v['totalValues'])))
//          );
          walletValuation = WalletValuation.fromJson(data).sortByValue(true);
        });
      }

//      WalletValuation walletValuation = (data['values'] as List).map((c) => Coin.fromJson(c));
      setState(() {
//        widget.coins.addAll(coins);
        isUpdating = false;
      });
    } else {
      throw Exception('Failed to fetch Coins');
    }
  }
}
