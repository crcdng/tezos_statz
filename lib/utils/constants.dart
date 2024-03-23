final int addressLength = 36;
final String addressPrefix = "tz";

final apiTickersParameters = {"quote": "USD"};
final apiTickersField = "last";

final donationAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

final tzstatsUri = Uri.https("tzpro.io/");
final githubUri = Uri.https("github.com/crcdng/tezos_statz");
final flutterUri = Uri.https("flutter.dev/");

final storageKey = "tzaddress";

// provided via environment variable
const tzproApiKey = String.fromEnvironment('TZPRO_KEY');
