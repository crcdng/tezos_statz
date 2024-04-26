import '../../common/errors.dart';
import '../models/address_model.dart';

class LocalStorage {
  final key, storage;

  LocalStorage({required this.storage, required this.key});

  Future<AddressModel> retrieveItem() async {
    String? item = storage.getString(key);

    if (item != null) {
      return AddressModel(address: item);
    } else {
      throw StorageItemNotFoundException();
    }
  }

  Future<bool> storeItem(String item) async {
    bool result = await storage.setString(key, item);

    // NOTE return value not properly documented, true means success
    // see https://github.com/flutter/flutter/issues/146070

    if (result) {
      return result;
    } else {
      throw StorageAccessException();
    }
  }
}
