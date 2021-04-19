import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:crypto_tracker/auth/auth-sub.dart';
import 'package:crypto_tracker/auth/check-auth.dart';
import 'package:crypto_tracker/components/bottom-navigation.dart';
import 'package:crypto_tracker/components/confirm-logout-dialog.dart';
import 'package:crypto_tracker/constants/screen-titles.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../../models/wallet-valuation.dart';
import 'package:crypto_tracker/screens/general/price-charts.dart';
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

    return WillPopScope(
      child: Scaffold(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('You have a total of '),
                    Text(
                        '${walletValuation.values.length}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(' currencies worth '),
                    Text(
                        '\$${walletValuation.totalValue}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    )
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
                                color: Colors.white,
                                spreadRadius: 0.2,
                                blurRadius: 0.5,
                                offset: Offset(0, 0.2), // changes position of shadow
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  coin,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                  ),
                                ),
                                Spacer(),
                                symbolPairButton(coin, pairs)

                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment: CrossAxisAlignment.end,
                            ),
                            Divider(),
                            Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      coinsValuation['coinCount'].toStringAsFixed(8),
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      coinsValuation['usdValue'] != null ? '\$${double.parse(coinsValuation['usdValue']).toStringAsFixed(2)}' : '\$0.00',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
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
      ),
    );
  }

  Widget symbolPairButton(String coin, List<String> pairs) {
    return SizedBox.fromSize(
      size: Size(30, 30), // button width and height
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
                          color: Colors.blue,
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
            child: Icon(Icons.show_chart_sharp, size: 20), // icon
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

    final response = await http.get('https://w0sizekdyd.execute-api.eu-west-1.amazonaws.com/dev/valuation/all/${await userAuthSub()}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success']) {
        setState(() {
          walletValuation = WalletValuation.fromJson(data).sortByValue(true);
        });
      }

      setState(() {
        isUpdating = false;
      });
    } else {
      throw Exception('Failed to fetch Coins');
    }
  }

  Future<void> fetchSymbolPairs() async {
    await getStoredSymbolPairs(); // Continue to request symbols in case a change has been made since last local storage save

    final response = await http.get('https://w0sizekdyd.execute-api.eu-west-1.amazonaws.com/dev/symbol-pairs');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print(data);
      print('----------');

      if (data['success']) {
        setState(() {
          symbolPairs = data['pairs'];
        });
      }
    } else {
      throw Exception('Failed to fetch Symbol Pairs');
    }
  }

  Future<bool> getStoredSymbolPairs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String allPairs = prefs.getString('allSymbolPairs');

    if (allPairs != null) {
      Map<String, dynamic> pairs = json.decode(allPairs);

      setState(() {
        symbolPairs = pairs;
      });

      return true;
    }

    return false;
  }

  void setStoredSymbolPairs(Map<String, dynamic> pairs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('allSymbolPairs', json.encode(pairs));
  }

}
