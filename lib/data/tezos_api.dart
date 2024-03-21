// Singleton
class TezosApi {
  TezosApi._privateConstructor();
  static final TezosApi _instance = TezosApi._privateConstructor();
  factory TezosApi() => _instance;

  retrieveBalance(String address) {
    // TODO
    // const apiKey = String.fromEnvironment('TZPRO_KEY');
    // if (apiKey.isEmpty) {
    //   throw AssertionError('API KEY is not retrievable');
    // }

    // print(apiKey);
    // var balanceResponse = await retrieveCurrentAddress().then((value) {
    //   print(Uri.https(constants.apiDomain, constants.apiPathAccount + value)
    //       .toString());

    //   return http.get(
    //       Uri.https(constants.apiDomain, constants.apiPathAccount + value),
    //       headers: {"X-API-Key": apiKey});
    // });
    // var tickerResponse = await http.get(
    //     Uri.https(constants.apiDomain, constants.apiPathTickers),
    //     headers: {"X-API-Key": apiKey});
    // if (!mounted) return;
    // setState(() {
    //   print(balanceResponse.body.toString());
    //   _amountTz = parseAmount(balanceResponse).toString() + " Tz";
    //   _amountUsd =
    //       (parseAmount(balanceResponse) * parseUSDQuote(tickerResponse))
    //               .toStringAsFixed(2) +
    //           " USD";
    // });
  }

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

  //  double parseAmount(data) =>
  //     json.decode(data.body)[constants.apiBalanceKey] ?? 0.0;

  // double parseUSDQuote(data) {
  //   var quotes = json
  //       .decode(data.body)
  //       .where((element) => element["quote"] == "USD")
  //       .toList();

  //   double average =
  //       quotes.fold(0.0, (value, element) => value + element["last"]) /
  //           quotes.length;

  //   return average;
  // }
}
