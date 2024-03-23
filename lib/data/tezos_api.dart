// Singleton
import 'dart:convert';
import 'package:http/http.dart' as http;

class TezosApi {
  TezosApi._privateConstructor();
  static final TezosApi _instance = TezosApi._privateConstructor();
  factory TezosApi() => _instance;

  // https://docs.tzpro.io/
  // Index API / Explorer API / Accounts

  double parseAmount(data) => json.decode(data)["spendable_balance"] ?? 0.0;

  double parseUSDQuote(data) {
    final quotes = json
        .decode(data)
        .where((element) => element["quote"] == "USD")
        .toList();
    final average =
        quotes.fold(0.0, (value, element) => value + element["last"]) /
            quotes.length;
    return average;
  }

  Future<double> retrieveBalance(String address) async {
    const apiKey = String.fromEnvironment('TZPRO_KEY');

    if (apiKey.isEmpty) {
      throw AssertionError('API KEY is not retrievable');
    }

    final response = await http.get(
        Uri.https("api.tzpro.io", "/explorer/account/" + address),
        headers: {"X-API-Key": apiKey});

    return parseAmount(response.body);
  }

  Future<double> retrieveBalanceInUsd(String address) async {
    const apiKey = String.fromEnvironment('TZPRO_KEY');

    if (apiKey.isEmpty) {
      throw AssertionError('API KEY is not retrievable');
    }

    final balanceResponse = await http.get(
        Uri.https("api.tzpro.io", "/explorer/account/" + address),
        headers: {"X-API-Key": apiKey});

    final tickerResponse = await http.get(
        Uri.https("api.tzpro.io", "/markets/tickers/"),
        headers: {"X-API-Key": apiKey});

    return parseAmount(balanceResponse.body) *
        parseUSDQuote(tickerResponse.body);
  }

  Future<List<Map<String, dynamic>>> retrieveTransactions(
      String address) async {
    const apiKey = String.fromEnvironment('TZPRO_KEY');

    if (apiKey.isEmpty) {
      throw AssertionError('API KEY is not retrievable');
    }

    // TODO adapt limit
    var response = await http.get(
        Uri.https(
            "api.tzpro.io",
            "/explorer/account/" + address + "/operations",
            {"type": "transaction", "order": "desc", "limit": "100"}),
        headers: {"X-API-Key": apiKey});

    return json.decode(response.body);
  }
}
