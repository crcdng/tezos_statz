final int addressLength = 36;
final String addressPrefix = "tz";

final apiTickersParameters = {"quote": "USD"};
final apiTickersField = "last";

final storageKey = "tzaddress";

// provided via environment variable
const tzproApiKey = String.fromEnvironment('TZPRO_KEY');
