import 'dart:core';

class WalletValuation {

  String totalValue;
  List<dynamic> values;
//  List<CoinsValuation> values;

  WalletValuation(
      this.totalValue,
      this.values
  );

  WalletValuation.fromJson(Map<String, dynamic> data):
        totalValue = data['totalValue'],
        values = data['values'];

  WalletValuation sortByValue(bool desc) {
    values.sort((a, b) => double.parse(a['usdValue']).compareTo(double.parse(b['usdValue'])));
    if (desc) values = values.reversed.toList();
    return this;
  }

  WalletValuation sortByCoinCount(bool desc) {
    values.sort((a, b) => a['coinCount'].compareTo(b['coinCount']));
    if (desc) values = values.reversed.toList();
    return this;
  }

  WalletValuation sortAlphabetically(bool desc) {
    values.sort((a, b) => a['coin'].compareTo(b['coin']));
    if (desc) values = values.reversed.toList();
    return this;
  }

}
