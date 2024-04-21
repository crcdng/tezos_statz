import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../common/errors.dart';
import '../../common/urls.dart';
import '../models/balance_model.dart';
import '../models/transaction_model.dart';

class RemoteDataSource {
  final http.Client client;

  RemoteDataSource({required this.client});

  Future<BalanceModel> retrieveBalance(String address) async {
    final balanceInTez = await _retrieveBalanceInTez(address);
    final quoteInUsd = await _retrieveQuoteInUsd();

    final balanceJson =
        '{"spendable_balance": $balanceInTez, "spendable_balance_usd": ${balanceInTez * quoteInUsd}}';

    return BalanceModel.fromJson(json.decode(balanceJson));
  }

  Future<List<TransactionModel>> retrieveTransactions(String address) async {
    // TODO adapt limit
    final response = await client.get(
        Uri.parse(Urls.retrieveTransactionsUrl(address)),
        headers: {"X-API-Key": Urls.tzproApiKey});

    if (response.statusCode == 200) {
      return _parseTransactions(response.body);
    } else {
      throw ServerException();
    }
  }

  Future<double> _retrieveBalanceInTez(String address) async {
    final response = await client.get(
        Uri.parse(Urls.retrieveBalanceUrl(address)),
        headers: {"X-API-Key": Urls.tzproApiKey});

    if (response.statusCode == 200) {
      return json.decode(response.body)['spendable_balance'];
    } else {
      throw ServerException();
    }
  }

  double _parseUSDQuote(data) {
    final quotes = json
        .decode(data)
        .where((element) => element["quote"] == "USD")
        .toList();
    final average =
        quotes.fold(0.0, (value, element) => value + element["last"]) /
            quotes.length;
    return average;
  }

  Future<double> _retrieveQuoteInUsd() async {
    final response = await client.get(Uri.parse(Urls.retrieveTickersUrl()),
        headers: {"X-API-Key": Urls.tzproApiKey});

    if (response.statusCode == 200) {
      return (_parseUSDQuote(response.body));
    } else {
      throw ServerException();
    }
  }

  List<TransactionModel> _parseTransactions(String responseBody) {
    final parsed =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed
        .map<TransactionModel>((json) => TransactionModel.fromJson(json))
        .toList();
  }
}
