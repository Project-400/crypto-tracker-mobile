import 'package:redux/redux.dart';
import 'package:crypto_tracker/redux/coins/coins.reducers.dart';
import 'package:crypto_tracker/redux/coins/coins.state.dart';

final _initialState = CoinsState();
final Store<CoinsState> store = Store<CoinsState>(coinsReducer, initialState: _initialState);
