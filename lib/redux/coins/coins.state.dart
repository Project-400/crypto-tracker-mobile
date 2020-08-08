class CoinsState {
  List<String> coins;

  CoinsState({this.coins = const []});

  CoinsState.fromAppState(CoinsState another) {
    coins = another.coins;
  }
}
