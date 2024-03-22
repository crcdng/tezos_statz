import 'package:flutter/foundation.dart';
import '../data/tezos_api.dart';

class Balance with ChangeNotifier {
  String amount = "";
  String amountInUsd = "";

  TezosApi api;

  Balance(TezosApi this.api);

  retrieve(String address) async {
    try {
      var apiResponse = await api.retrieveBalance(address);
      amount = apiResponse.toString();
    } catch (err) {
      amount = "";
    }
    notifyListeners();
  }

  retrieveInUsd(String address) async {
    try {
      var apiResponse = await api.retrieveBalanceInUsd(address);
      amountInUsd = apiResponse.toStringAsFixed(2);
    } catch (err) {
      amountInUsd = "";
    }
    notifyListeners();
  }
}
