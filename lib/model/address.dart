import 'package:flutter/foundation.dart';
import '../data/storage.dart';

class Address with ChangeNotifier {
  String value = "";
  Storage storage;

  Address(Storage this.storage);

  store(String address) {
    value = address;
    notifyListeners();
    storage.storeItem(address);
  }

  retrieve() async {
    value = await storage.retrieveItem();
    notifyListeners();
    return value;
  }

  bool isValid(String? str) {
    return (str != null &&
        str.length == 36 &&
        RegExp(r'^[A-Za-z0-9]+$').hasMatch(str) &&
        (str.startsWith("tz1") ||
            str.startsWith("tz2") ||
            str.startsWith("tz3")));
  }
}
