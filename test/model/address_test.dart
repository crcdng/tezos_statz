import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_statz/data/storage.dart';
import 'package:tezos_statz/model/address.dart';

// NOTE instead of the MockStorage we could use the preference package directly with testing support https://docs.flutter.dev/cookbook/persistence/key-value#testing-support
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
        expect(sut.value, address);
        notified = true;
      });
      sut.store(address);
      expect(notified, true);
    });
  });

  group(' retrieve address', () {
    test('retrieve address calls retrieval of data', () {
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
