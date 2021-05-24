import 'package:shared_preferences/shared_preferences.dart';

Future<String> retrieveAddress() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("tzaddress") ?? "";
}

Future<String> storeAddress(String tzaddress) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("tzaddress", tzaddress);
  return tzaddress;
}
