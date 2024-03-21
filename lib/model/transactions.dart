import 'package:flutter/foundation.dart';

import '../data/tezos_api.dart';

class Transactions with ChangeNotifier {
  List<Map<String, dynamic>> transactions = [];

  Transactions(TezosApi api);

  retrieve(String address) async {
    // TODO
  }
}
