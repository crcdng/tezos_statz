import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/common/urls.dart';
import 'package:tezos_statz/data/datasources/remote_datasource.dart';
import 'package:tezos_statz/data/models/balance_model.dart';
import 'package:tezos_statz/data/models/transaction_model.dart';

import '../../utils/read_json.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late RemoteDataSource sut;
  late MockHttpClient mockHttpClient;
  const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
  const testNonAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pn";

  final testBalanceResponseJsonData =
      readJson('test/utils/balance_response.json');

  final testTickersResponseJsonData =
      readJson('test/utils/tickers_response.json');

  final testTransactionsResponseJsonData =
      readJson('test/utils/transactions_response.json');

  setUp(() {
    mockHttpClient = MockHttpClient();
    sut = RemoteDataSource(client: mockHttpClient);
  });

  group('retrieve balance', () {
    test('should return a valid model when both HTTP responses are 200',
        () async {
      when(() => mockHttpClient
          .get(Uri.parse(Urls.retrieveBalanceUrl(testAddress)),
              headers: {"X-API-Key": Urls.tzproApiKey})).thenAnswer(
          (_) async => http.Response(testBalanceResponseJsonData, 200));

      when(() => mockHttpClient.get(Uri.parse(Urls.retrieveTickersUrl()),
              headers: {"X-API-Key": Urls.tzproApiKey}))
          .thenAnswer(
              (_) async => http.Response(testTickersResponseJsonData, 200));

      final result = await sut.retrieveBalance(testAddress);
      expect(result, isA<BalanceModel>());
    });

    test('should throw an exception when the balance HTTP response is 404', () {
      when(() => mockHttpClient.get(
              Uri.parse(Urls.retrieveBalanceUrl(testNonAddress)),
              headers: {"X-API-Key": Urls.tzproApiKey}))
          .thenAnswer((_) async => http.Response('not found', 404));

      when(() => mockHttpClient.get(Uri.parse(Urls.retrieveTickersUrl()),
              headers: {"X-API-Key": Urls.tzproApiKey}))
          .thenAnswer(
              (_) async => http.Response(testTickersResponseJsonData, 200));

      expect(
          sut.retrieveBalance(testNonAddress), throwsA(isA<ServerException>()));
    });

    test('should throw an exception when the tickers HTTP response is 404', () {
      when(() => mockHttpClient
          .get(Uri.parse(Urls.retrieveBalanceUrl(testAddress)),
              headers: {"X-API-Key": Urls.tzproApiKey})).thenAnswer(
          (_) async => http.Response(testBalanceResponseJsonData, 200));

      when(() => mockHttpClient.get(Uri.parse(Urls.retrieveTickersUrl()),
              headers: {"X-API-Key": Urls.tzproApiKey}))
          .thenAnswer((_) async => http.Response('not found', 404));

      expect(sut.retrieveBalance(testAddress), throwsA(isA<ServerException>()));
    });

    test('should throw an exception when both HTTP responses are 404', () {
      when(() => mockHttpClient.get(
              Uri.parse(Urls.retrieveBalanceUrl(testNonAddress)),
              headers: {"X-API-Key": Urls.tzproApiKey}))
          .thenAnswer((_) async => http.Response('not found', 404));

      when(() => mockHttpClient.get(Uri.parse(Urls.retrieveTickersUrl())))
          .thenAnswer((_) async => http.Response('not found', 404));

      expect(
          sut.retrieveBalance(testNonAddress), throwsA(isA<ServerException>()));
    });
  });

  group('retrieve transactions', () {
    test('should return a list of transcations if HTTP response is 200',
        () async {
      when(() => mockHttpClient
          .get(Uri.parse(Urls.retrieveTransactionsUrl(testAddress)),
              headers: {"X-API-Key": Urls.tzproApiKey})).thenAnswer(
          (_) async => http.Response(testTransactionsResponseJsonData, 200));

      final result = await sut.retrieveTransactions(testAddress);
      expect(result, isA<List<TransactionModel>>());
    });

    test('should throw an exception if HTTP response is 404', () {
      when(() => mockHttpClient.get(
              Uri.parse(Urls.retrieveTransactionsUrl(testNonAddress)),
              headers: {"X-API-Key": Urls.tzproApiKey}))
          .thenAnswer((_) async => http.Response('not found', 404));
      expect(sut.retrieveTransactions(testNonAddress),
          throwsA(isA<ServerException>()));
    });
  });
}
