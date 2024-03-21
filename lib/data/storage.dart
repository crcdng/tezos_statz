import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Storage({required this.key});
  final key;

  Future<String> retrieveItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  Future<String> storeItem(String item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, item);
    return item;
  }
}
