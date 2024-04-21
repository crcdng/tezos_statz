// https://docs.tzpro.io/
// Explorer API / Accounts
// Market API / Market Tickers
// Explorer API / Operations

class Urls {
  static const tzproApiKey = String.fromEnvironment('TZPRO_KEY');

  static String retrieveBalanceUrl(String address) =>
      'https://api.tzpro.io/explorer/account/$address';

  static String retrieveTickersUrl() => 'https://api.tzpro.io/markets/tickers';

  static String retrieveTransactionsUrl(String address) =>
      'https://api.tzpro.io/explorer/account/$address/operations?type=transaction&limit=100&order=desc';
}
