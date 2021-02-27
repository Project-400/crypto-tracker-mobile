import 'dart:core';

class BinanceKlinePoint {

  String openPrice;
  String closePrice;
  String highPrice;
  String lowPrice;
  String volume;
  String quoteAssetVolume;
  String takerBuyBaseAssetVolume;
  String takerBuyQuoteAssetVolume;
  num numOfTrades;
  num openTime;
  num closeTime;

  BinanceKlinePoint(
      this.openTime,
      this.openPrice,
      this.closePrice,
      this.highPrice,
      this.lowPrice,
      this.volume,
      this.closeTime,
      this.quoteAssetVolume,
      this.numOfTrades,
      this.takerBuyBaseAssetVolume,
      this.takerBuyQuoteAssetVolume,
  );

  BinanceKlinePoint.fromJson(List<dynamic> values):
        openPrice = values[1],
        closePrice = values[4],
        highPrice = values[2],
        lowPrice = values[3],
        volume = values[5],
        quoteAssetVolume = values[7],
        takerBuyBaseAssetVolume = values[9],
        takerBuyQuoteAssetVolume = values[10],
        numOfTrades = values[8],
        openTime = values[0],
        closeTime = values[6];

}
