import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/data/tezos_api.dart';
import 'package:tezos_statz/model/balance.dart';

class MockApi extends Mock implements TezosApi {}

void main() {
  late Balance sut;
  late MockApi mockApi;

  setUp(() {
    mockApi = MockApi();
    sut = Balance(mockApi);
  });

  test('field has default value', () async {
    expect(sut.amount, "");
  });

  group('balance in Tez', () {
    test('retrieve balance for address calls the tezos api', () {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      when(() => mockApi.retrieveBalance(address))
          .thenAnswer((_) async => 3.33);
      sut.retrieve(address);
      verify(() => mockApi.retrieveBalance(address)).called(1);
    });

    test('retrieve balance for address sets field', () async {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      final mockApiAnswer = 3.33;
      when(() => mockApi.retrieveBalance(address))
          .thenAnswer((_) async => mockApiAnswer);
      await sut.retrieve(address);
      expect(sut.amount, mockApiAnswer.toString());
    });

    test('retrieve balance notifies listeners', () async {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      when(() => mockApi.retrieveBalance(address))
          .thenAnswer((_) async => 3.33);
      var notified = false;
      sut.addListener(() {
        notified = true;
      });
      await sut.retrieve(address);
      expect(notified, true);
    });

    test('retrieve balance with API error sets field to empty string',
        () async {
      final invalidAddress = "tzffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      when(() => mockApi.retrieveBalance(invalidAddress))
          .thenThrow(AssertionError("an API error has occurred"));
      await sut.retrieve(invalidAddress);
      expect(sut.amount, "");
    });
  });

  group('balance in USD', () {
    test('retrieve retrieveInUsd for address calls the tezos api', () {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      when(() => mockApi.retrieveBalanceInUsd(address))
          .thenAnswer((_) async => 4.01);
      sut.retrieveInUsd(address);
      verify(() => mockApi.retrieveBalanceInUsd(address)).called(1);
    });

    test('retrieveInUsd balance for address sets field', () async {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      final mockApiAnswer = 4.01;
      when(() => mockApi.retrieveBalanceInUsd(address))
          .thenAnswer((_) async => mockApiAnswer);
      await sut.retrieveInUsd(address);
      expect(sut.amountInUsd, mockApiAnswer.toString());
    });

    test('retrieveInUsd balance notifies listeners', () async {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      when(() => mockApi.retrieveBalanceInUsd(address))
          .thenAnswer((_) async => 4.01);
      var notified = false;
      sut.addListener(() {
        notified = true;
      });
      await sut.retrieveInUsd(address);
      expect(notified, true);
    });

    test('retrieveInUsd balance with API error sets field to empty value',
        () async {
      final invalidAddress = "tzffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      when(() => mockApi.retrieveBalanceInUsd(invalidAddress))
          .thenThrow(AssertionError("an API error has occurred"));
      await sut.retrieveInUsd(invalidAddress);
      expect(sut.amountInUsd, "");
    });
  });
}
