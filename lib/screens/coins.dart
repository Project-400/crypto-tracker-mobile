import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:crypto_tracker/auth/check-auth.dart';
import 'package:crypto_tracker/components/bottom-navigation.dart';
import 'package:crypto_tracker/components/confirm-logout-dialog.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../models/wallet-valuation.dart';
import 'package:crypto_tracker/screens/price-charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoinsScreen extends StatefulWidget {
  CoinsScreen({Key key, this.title}) : super(key: key);

  final String title;
//  final List<Coin> coins = [];

  @override
  _CoinsScreenState createState() => _CoinsScreenState();
}

class _CoinsScreenState extends State<CoinsScreen> {
  bool isLoggedIn = false;

  bool isUpdating = false;
  WalletValuation walletValuation;
  Map<String, dynamic> symbolPairs;

  @override
  void initState() {
    super.initState();
    fetchCoins();
    fetchSymbolPairs();
  }

  @override
  Widget build(BuildContext context) {
    checkIfAuthenticated().then((success) {
      setState(() {
        isLoggedIn = success;
      });
    });

    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.title,
//            style: TextStyle(
//                color: Colors.black
//            ),
          ),
//        backgroundColor: Colors.transparent,
//        elevation: 0.0
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
      bottomNavigationBar: BottomNavBar(selectedScreen: ScreenTitles.COINS_SCREEN),
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
                  final coinsValuation = walletValuation.values[index];
                  String coin = coinsValuation['coin'];
                  List<String> pairs = symbolPairs[coinsValuation['coin']].cast<String>();

                  return Container(
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
                                  coin,
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
                        Column(
                          children: [
                            symbolPairButton(coin, pairs)
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                        )
                      ],
                    )
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

  Widget symbolPairButton(String coin, List<String> pairs) {
    return SizedBox.fromSize(
      size: Size(40, 40), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.orange, // button color
          child: InkWell(
            splashColor: Colors.green, // splash color
            onTap: () async {
              final selectedPair = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text(
                        'Currency Pair',
                      textAlign: TextAlign.center,
                    ),
                    children: pairs.map((pair) => Expanded(
                        child: SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, '$coin$pair');
                        },
                        child: Container(
                          child: Text(
                            '$coin$pair',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white
                            ),
                          ),
                          color: Color(0xff888888),
                          padding: EdgeInsets.symmetric(vertical: 6),
                          alignment: Alignment.center,
                        ),
                      )
                    )).toList()
                  );
                }
              );

              if (selectedPair != null) Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  PriceChartsScreen(title: 'Price Charts', symbol: selectedPair))
              );
            }, // button pressed
            child: Icon(Icons.show_chart_sharp, size: 30), // icon
          ),
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

  Future<void> fetchSymbolPairs() async {
    print('FETCH SYMBOL PAIRS');

    await getStoredSymbolPairs(); // Continue to request symbols in case a change has been made since last local storage save

    final response = await http.get('http://localhost:15005/symbol-pairs');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

//      print('SYMBOL PAIRS');
      print(data);
      print('----------');

      if (data['success']) {
        setState(() {
          symbolPairs = data['pairs'];
//          setStoredSymbolPairs(symbolPairs);
        });
      }
    } else {
      throw Exception('Failed to fetch Symbol Pairs');
    }
  }

  Future<bool> getStoredSymbolPairs() async {
    print('GET STORED SYMBOL PAIRS');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String allPairs = prefs.getString('allSymbolPairs');

    if (allPairs != null) {
      print('GOT STORED SYMBOL PAIRS');

      Map<String, dynamic> pairs = json.decode(allPairs);

      setState(() {
        symbolPairs = pairs;
      });

      return true;
    }
    print('NO STORED SYMBOL PAIRS');


    return false;
  }

  void setStoredSymbolPairs(Map<String, dynamic> pairs) async {
    print('SET STORED SYMBOL PAIRS');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('allSymbolPairs', json.encode(pairs));
  }

}
