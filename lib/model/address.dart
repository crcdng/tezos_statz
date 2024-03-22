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
}
