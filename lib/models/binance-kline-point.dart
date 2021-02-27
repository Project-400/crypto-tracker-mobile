import 'dart:core';

import 'package:trading_chart/entity/k_line_entity.dart';

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

  KLineEntity toK_Line() {
    return KLineEntity.fromJson({
      'open': double.parse(openPrice),
      'close': double.parse(closePrice),
      'high': double.parse(highPrice),
      'low': double.parse(lowPrice),
      'vol': double.parse(volume),
      'amount': double.parse(takerBuyBaseAssetVolume),
      'time': openTime
    });
  }
}
