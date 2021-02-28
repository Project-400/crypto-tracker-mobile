import 'dart:core';

class CoinIndividualValues {

  String usdtValue;
  String busdValue;
  String btcValue;
  String ethValue;
  String bnbValue;

  CoinIndividualValues(
      this.usdtValue,
      this.busdValue,
      this.btcValue,
      this.ethValue,
      this.bnbValue
  );

  CoinIndividualValues.fromJson(Map<String, dynamic> data):
        usdtValue = data['usdtValue'],
        busdValue = data['busdValue'],
        btcValue = data['btcValue'],
        ethValue = data['ethValue'],
        bnbValue = data['bnbValue'];

}

class CoinTotalValues {

  String usdtTotalValue;
  String busdTotalValue;
  String btcToUsdTotalValue;
  String ethToUsdTotalValue;
  String bnbToUsdTotalValue;
  String btcTotalValue;
  String ethTotalValue;
  String bnbTotalValue;

  CoinTotalValues(
      this.usdtTotalValue,
      this.busdTotalValue,
      this.btcToUsdTotalValue,
      this.ethToUsdTotalValue,
      this.bnbToUsdTotalValue,
      this.btcTotalValue,
      this.ethTotalValue,
      this.bnbTotalValue
  );

  CoinTotalValues.fromJson(Map<String, dynamic> data):
        usdtTotalValue = data['usdtTotalValue'],
        busdTotalValue = data['busdTotalValue'],
        btcToUsdTotalValue = data['btcToUsdTotalValue'],
        ethToUsdTotalValue = data['ethToUsdTotalValue'],
        bnbToUsdTotalValue = data['bnbToUsdTotalValue'],
        btcTotalValue = data['btcTotalValue'],
        ethTotalValue = data['ethTotalValue'],
        bnbTotalValue = data['bnbTotalValue'];

}

class CoinsValuation {

  String coin;
  num coinCount;
  bool isNonMainstream;
  String usdValue;
  CoinIndividualValues individualValues;
  CoinTotalValues totalValues;

  CoinsValuation(
      this.coin,
      this.coinCount,
      this.isNonMainstream,
      this.usdValue,
      this.individualValues,
      this.totalValues
  );

  CoinsValuation.fromJson(Map<String, dynamic> data):
        coin = data['coin'],
        coinCount = data['coinCount'],
        isNonMainstream = data['isNonMainstream'],
        usdValue = data['usdValue'],
        individualValues = data['individualValues'].cast<CoinIndividualValues>(),
        totalValues = data['totalValues'].cast<CoinTotalValues>();

}
