import 'dart:core';
import 'coins-valuation.dart';

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

}
