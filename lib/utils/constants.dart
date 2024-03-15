final int addressLength = 36;
final String addressPrefix = "tz";

final siteDomain = "tzstats.com";
final apiDomain = "api.tzstats.com";
final apiPathAccount = "/explorer/account/";
final apiBalanceKey = "total_balance";

final apiTransactionsPostfix = "/operations";
final apiTransactionsParameters = {
  "type": "transaction",
  "order": "desc",
  "limit": "100"
};

final apiPathTickers = "/markets/tickers/";
final apiTickersParameters = {"quote": "USD"};
final apiTickersField = "last";

final donationAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

final tzstatsUri = Uri.https("https://tzpro.io/");
final githubUri = Uri.https("https://github.com/crcdng/tezos_statz");
final crcdngUri = Uri.https("https://twitter.com/crcdng/");
final flutterUri = Uri.https("https://flutter.dev/");
