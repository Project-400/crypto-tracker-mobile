class CoinNetwork {

  String network;
  String coin;
  double withdrawIntegerMultiple = 0;
  bool isDefault = false;
  bool depositEnable = false;
  bool withdrawEnable = false;
  String depositDesc;
  String withdrawDesc;
  String specialTips;
  String name;
  bool resetAddressStatus = false;
  String addressRegex;
  String memoRegex;
  double withdrawFee;
  double withdrawMin;
  double withdrawMax;
  double minConfirm;
  double unLockConfirm;

  CoinNetwork(
      this.network,
      this.coin,
      this.withdrawIntegerMultiple,
      this.isDefault,
      this.depositEnable,
      this.withdrawEnable,
      this.depositDesc,
      this.withdrawDesc,
      this.specialTips,
      this.name,
      this.resetAddressStatus,
      this.addressRegex,
      this.memoRegex,
      this.withdrawFee,
      this.withdrawMin,
      this.withdrawMax,
      this.minConfirm,
      this.unLockConfirm
  );

  CoinNetwork.fromJson(Map<String, dynamic> json)
      : network = json['network'],
        coin = json['coin'],
        withdrawIntegerMultiple = json['withdrawIntegerMultiple'].toDouble(),
        isDefault = json['isDefault'],
        depositEnable = json['depositEnable'],
        withdrawEnable = json['withdrawEnable'],
        depositDesc = json['depositDesc'],
        withdrawDesc = json['withdrawDesc'],
        specialTips = json['specialTips'],
        name = json['name'],
        resetAddressStatus = json['resetAddressStatus'],
        addressRegex = json['addressRegex'],
        memoRegex = json['memoRegex'],
        withdrawFee = json['withdrawFee'].toDouble(),
        withdrawMin = json['withdrawMin'].toDouble(),
        withdrawMax = json['withdrawMax'].toDouble(),
        minConfirm = json['minConfirm'].toDouble(),
        unLockConfirm = json['unLockConfirm'].toDouble();

}
