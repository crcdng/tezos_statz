import 'package:flutter/foundation.dart';

import '../data/tezos_api.dart';

class Transactions with ChangeNotifier {
  List<Map<String, dynamic>> items = [];

  TezosApi api;

  Transactions(TezosApi this.api);

  retrieve(String address) async {
    try {
      var apiResponse = await api.retrieveTransactions(address);
      items = apiResponse;
    } catch (err) {
      items = [];
    }
    notifyListeners();
  }
}
