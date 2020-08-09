import 'dart:core';
import 'package:crypto_tracker/models/coin-network.dart';
//import 'package:json_annotation/json_annotation.dart';
//part 'coin.g.dart';
//
//@JsonSerializable()
class Coin {

  String coin;
  bool depositAllEnable = false;
  bool withdrawAllEnable = false;
  String name;
  double free;
  double locked;
  double freeze;
  double withdrawing;
  double ipoing;
  double ipoable;
  double storage;
  bool isLegalMoney;
  bool trading;
//  List<CoinNetwork> networkList;

  Coin(
    this.coin,
    this.depositAllEnable,
    this.withdrawAllEnable,
    this.name,
    this.free,
    this.locked,
    this.freeze,
    this.withdrawing,
    this.ipoing,
    this.ipoable,
    this.storage,
    this.isLegalMoney,
    this.trading
//    this.networkList
  );

  Coin.fromJson(Map<String, dynamic> json)
      : coin = json['coin'],
        depositAllEnable = json['depositAllEnable'],
        withdrawAllEnable = json['withdrawAllEnable'],
        name = json['name'],
        free = json['free'].toDouble(),
        locked = json['locked'].toDouble(),
        freeze = json['freeze'].toDouble(),
        withdrawing = json['withdrawing'].toDouble(),
        ipoing = json['ipoing'].toDouble(),
        ipoable = json['ipoable'].toDouble(),
        storage = json['storage'].toDouble(),
        isLegalMoney = json['isLegalMoney'],
        trading = json['trading'];
//        networkList = json['networkList'];

}
