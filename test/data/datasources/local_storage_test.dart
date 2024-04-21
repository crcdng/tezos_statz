import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/data/datasources/local_storage.dart';
import 'package:tezos_statz/data/models/address_model.dart';

// NOTE instead of the Mock we could test the preference package directly via its testing support https://docs.flutter.dev/cookbook/persistence/key-value#testing-support
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late LocalStorage sut;
  const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
  const testKey = "testkey";
  const testAddressModel =
      AddressModel(address: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk');

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    sut = LocalStorage(storage: mockSharedPreferences, key: testKey);
  });

  group('store address', () {
    test('should call storage set method', () async {
      when(() => mockSharedPreferences.setString(testKey, testAddress))
          .thenAnswer((_) async => true);
      await sut.storeItem(testAddress);
      verify(() => mockSharedPreferences.setString(testKey, testAddress))
          .called(1);
    });

    // NOTE not clear if it is correct to expect this
    // https://github.com/flutter/flutter/issues/146070
    test('should return true on successful operation', () async {
      when(() => mockSharedPreferences.setString(testKey, testAddress))
          .thenAnswer((_) async => true);
      final result = await sut.storeItem(testAddress);
      expect(result, true);
    });
  });

  group(' retrieve address', () {
    test('should call storage get method', () async {
      when(() => mockSharedPreferences.getString(testKey)).thenReturn("");
      await sut.retrieveItem();
      verify(() => mockSharedPreferences.getString(testKey)).called(1);
    });

    test('should return true on successful operation', () async {
      when(() => mockSharedPreferences.setString(testKey, testAddress))
          .thenAnswer((_) async => true);

      final result = await sut.storeItem(testAddress);

      expect(result, true);
    });

    test(
        'should throw StorageItemNotFoundException if the storage does not return an item',
        () async {
      when(() => mockSharedPreferences.getString(testKey)).thenReturn(null);

      expect(() => sut.retrieveItem(),
          throwsA(isA<StorageItemNotFoundException>()));
    });

    test('should return Model if the storage returns an item', () async {
      when(() => mockSharedPreferences.getString(testKey))
          .thenReturn(testAddress);

      final result = await sut.retrieveItem();

      // instances of AddressModel must be comparable for this test to succeed
      expect(result, testAddressModel);
    });
  });
}
