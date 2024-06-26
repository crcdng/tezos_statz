import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/data/datasources/local_storage.dart';
import 'package:tezos_statz/data/models/address_model.dart';
import 'package:tezos_statz/data/repositories/address_repository_impl.dart';
import 'package:tezos_statz/domain/entities/address_entity.dart';
import 'package:tezos_statz/domain/repositories/address_repository.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late MockLocalStorage mockLocalStorage;
  late AddressRepositoryImpl sut;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    sut = AddressRepositoryImpl(storage: mockLocalStorage);
  });

  test('should be a subclass of AddressRepository', () {
    expect(sut, isA<AddressRepository>());
  });

  group('Store an Address', () {
    test('should store a valid tz1 address', () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockLocalStorage.storeItem(testAddress))
          .thenAnswer((_) async => true);

      final result = await sut.storeAddress(testAddress);

      expect(result, Right(true));
    });

    test('should store a valid tz2 address', () async {
      const testAddress = "tz2ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockLocalStorage.storeItem(testAddress))
          .thenAnswer((_) async => true);

      final result = await sut.storeAddress(testAddress);

      expect(result, Right(true));
    });

    test('should store a valid tz3 address', () async {
      const testAddress = "tz3ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockLocalStorage.storeItem(testAddress))
          .thenAnswer((_) async => true);

      final result = await sut.storeAddress(testAddress);

      expect(result, Right(true));
    });

    test(
        'should return a AddressFormatFailure when the address starts with wrong prefix',
        () async {
      const testAddress = "tz4ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      final result = await sut.storeAddress(testAddress);

      expect(
          result,
          const Left(AddressFormatFailure(
              'The address does not have the correct format.')));
    });

    test('should return a AddressFormatFailure when the address is too short',
        () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pn";

      final result = await sut.storeAddress(testAddress);

      expect(
          result,
          const Left(AddressFormatFailure(
              'The address does not have the correct format.')));
    });

    test('should return a AddressFormatFailure when the address is too long',
        () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnkd";

      final result = await sut.storeAddress(testAddress);

      expect(
          result,
          const Left(AddressFormatFailure(
              'The address does not have the correct format.')));
    });

    test(
        'should return a AddressFormatFailure when the address contains a special character',
        () async {
      const testAddress = "tz1ffYDwFHchNy5vA😀isuCAK2yVxh4Ye9pnk";

      final result = await sut.storeAddress(testAddress);

      expect(
          result,
          const Left(AddressFormatFailure(
              'The address does not have the correct format.')));
    });

    test(
        'should return a AddressFormatFailure when the address is the empty string',
        () async {
      const testAddress = "";

      final result = await sut.storeAddress(testAddress);

      expect(
          result,
          const Left(AddressFormatFailure(
              'The address does not have the correct format.')));
    });

    test(
        'should return a StorageItemStoreFailure when LocalStorage returns false',
        () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockLocalStorage.storeItem(testAddress))
          .thenAnswer((_) async => false);

      final result = await sut.storeAddress(testAddress);

      expect(
          result,
          const Left(StorageItemStoreFailure(
              'The address storage failed to report success.')));
    });

    test(
        'should return a StorageAccessFailure when LocalStorage throws a StorageAccessException',
        () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockLocalStorage.storeItem(testAddress))
          .thenThrow(StorageAccessException());

      final result = await sut.storeAddress(testAddress);

      expect(
          result,
          const Left(
              StorageAccessFailure('The address storage cannot be accessed.')));
    });
  });

  group('Retrieve an Address', () {
    test('should return an AddressEntity', () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockLocalStorage.retrieveItem())
          .thenAnswer((_) async => AddressModel(address: testAddress));

      final result = await sut.retrieveAddress();

      expect(result, Right(AddressEntity(address: testAddress)));
    });

    test(
        'should return a StorageItemRetrieveFailure when LocalStorage throws a StorageItemNotFoundException',
        () async {
      when(() => mockLocalStorage.retrieveItem())
          .thenThrow(StorageItemNotFoundException());

      final result = await sut.retrieveAddress();

      expect(
          result,
          const Left(StorageItemRetrieveFailure(
              'The Address could not be retrieved from storage.')));
    });
  });
}
