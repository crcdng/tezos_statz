import 'package:shared_preferences/shared_preferences.dart';

const addressKey = "tzaddress";
const addressBookKey = "addressbook";

Future<String> retrieveCurrentAddress() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(addressKey) ?? "";
}

Future<String> storeCurrentAddress(String address) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(addressKey, address);
  return address;
}

Future<List<String>> retrieveAddressBook() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> addressBook = prefs.getStringList(addressBookKey) ?? [];
  return addressBook;
}

Future<List<String>> storeInAddressBook(Future<String> futureAddress) async {
  var currentEntries = await retrieveAddressBook();
  var address = await futureAddress;
  if (!currentEntries.contains(address)) {
    currentEntries.add(address);
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(addressBookKey, currentEntries);
  }
  return currentEntries;
}

Future<List<String>> removeFromAddressBook(String address) async {
  var currentEntries = await retrieveAddressBook();
  final prefs = await SharedPreferences.getInstance();
  currentEntries.remove(address);
  prefs.setStringList(addressBookKey, currentEntries);
  return currentEntries;
}
