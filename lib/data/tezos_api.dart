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
        .decode(data.body)
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

    return parseAmount(balanceResponse) * parseUSDQuote(tickerResponse);
  }

  // var tickerResponse = await http.get(
  //     Uri.https(constants.apiDomain, constants.apiPathTickers),
  //     headers: {"X-API-Key": apiKey});

  // setState(() {
  //   print(balanceResponse.body.toString());
  //   _amountTz = parseAmount(balanceResponse).toString() + " Tz";
  //   _amountUsd =
  //       (parseAmount(balanceResponse) * parseUSDQuote(tickerResponse))
  //               .toStringAsFixed(2) +
  //           " USD";
  // });

  retrieveTransactions(String address) {
    // TODO
    // final domain = constants.apiDomain;
    // final path =
    //     constants.apiPathAccount + address + constants.apiTransactionsPostfix;
    // final parameters = constants.apiTransactionsParameters;
    // const apiKey = String.fromEnvironment('TZPRO_KEY');
    // if (apiKey.isEmpty) {
    //   throw AssertionError('API KEY is not retrievable');
    // }

    // var result = await http.get(Uri.https(domain, path, parameters),
    //     headers: {"X-API-Key": apiKey});

    // if (result.statusCode == 200) {
    //   setState(() {
    //     _transactions = json.decode(result.body);
    //   });
    // }
  }
}
