import 'package:flutter/foundation.dart';
import '../data/tezos_api.dart';

class Balance with ChangeNotifier {
  String amount = "";
  Balance(TezosApi api);

  retrieve(String address) async {
    // TODO
  }
}
