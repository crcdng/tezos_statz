final int addressLength = 36;
final String addressPrefix = "tz";

final apiDomain = "api.tzpro.io";
final apiPathAccount = "/explorer/account/";
final apiBalanceKey = "spendable_balance";

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

final tzstatsUri = Uri.https("tzpro.io/");
final githubUri = Uri.https("github.com/crcdng/tezos_statz");
final flutterUri = Uri.https("flutter.dev/");

final storageKey = "tzaddress";

// provided via environment variable
const tzproApiKey = String.fromEnvironment('TZPRO_KEY');
