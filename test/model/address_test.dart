import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_statz/data/storage.dart';
import 'package:tezos_statz/model/address.dart';

// NOTE instead of the MockStorage we could test the preference package directly with its testing support https://docs.flutter.dev/cookbook/persistence/key-value#testing-support
class MockStorage extends Mock implements Storage {}

void main() {
  late Address sut;
  late MockStorage mockStorage;

  setUp(() {
    mockStorage = MockStorage();
    sut = Address(mockStorage);
  });

  test('field has default value', () async {
    expect(sut.value, "");
  });

  test('valid addresses are confirmed', () async {
    final validAdresses = [
      "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk",
      "tz2TPCAL3hTSKy5Jv1T7AHmgvX6bZ43tj1YD"
    ];
    for (var validAdress in validAdresses) {
      expect(sut.isValid(validAdress), true);
    }
  });

  test('invalid addresses are rejected', () async {
    final invalidAdresses = [
      "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pn",
      "tb2TPCAL3hTSKy5Jv1T7AHmgvX6bZ43tj1YD",
      "tz2TPCAL3hTSKy5Jv1T7ÄHmgvX6bZ43tj1YD",
      "lol",
      "",
      null
    ];
    for (var invalidAdress in invalidAdresses) {
      expect(sut.isValid(invalidAdress), false);
    }
  });

  group(' store address', () {
    test('store address calls storage of data', () {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      when(() => mockStorage.storeItem(address)).thenAnswer((_) async => null);
      sut.store(address);
      verify(() => mockStorage.storeItem(address)).called(1);
    });

    test('store address sets field', () {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      when(() => mockStorage.storeItem(address)).thenAnswer((_) async => null);
      sut.store(address);
      expect(sut.value, address);
    });

    // testing the change notifier
    // https://docs.flutter.dev/cookbook/persistence/key-value#testing-support

    test('store address notifies listeners', () {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      when(() => mockStorage.storeItem(address)).thenAnswer((_) async => null);
      var notified = false;
      sut.addListener(() {
        notified = true;
      });
      sut.store(address);
      expect(notified, true);
    });
  });

  group(' retrieve address', () {
    test('retrieve address calls retrieval of data from storage', () {
      when(() => mockStorage.retrieveItem()).thenAnswer((_) async => "");
      sut.retrieve();
      verify(() => mockStorage.retrieveItem()).called(1);
    });

    test('retrieve address sets field', () async {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      when(() => mockStorage.retrieveItem()).thenAnswer((_) async => address);
      expect(sut.value, "");
      await sut.retrieve();
      expect(sut.value, address);
    });

    test('retrieve address notifies listeners', () async {
      when(() => mockStorage.retrieveItem()).thenAnswer((_) async => "");
      var notified = false;
      sut.addListener(() {
        notified = true;
      });
      await sut.retrieve();
      expect(notified, true);
    });

    test('retrieve address retrieves default value', () async {
      when(() => mockStorage.retrieveItem()).thenAnswer((_) async => "");
      final value = await sut.retrieve();
      expect(sut.value, value);
    });
  });
}