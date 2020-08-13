import 'dart:core';

class PriceTimePeriods {
  double min5;
  double min10;
  double min30;
  double hour;
  double hour3;
  double hour6;
  double hour12;
  double hour24;
}

class PriceChangeStats {

  String symbol;
  String base;
  String quote;
  double currentPrice;
  Map<String, dynamic> previousPrices;
  Map<String, dynamic> priceChanges;
  Map<String, dynamic> pricePercentageChanges;

  PriceChangeStats(
      this.symbol,
      this.base,
      this.quote,
      this.currentPrice,
      this.previousPrices,
      this.priceChanges,
      this.pricePercentageChanges
  );

  PriceChangeStats.fromJson(Map<String, dynamic> json)
      : symbol = json['symbol'],
        base = json['base'],
        quote = json['quote'],
        currentPrice = json['currentPrice'].toDouble(),
        previousPrices = json['previousPrices'],
        priceChanges = json['priceChanges'],
        pricePercentageChanges = json['pricePercentageChanges'];

}
