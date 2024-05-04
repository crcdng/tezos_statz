import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/domain/entities/address_entity.dart';
import 'package:tezos_statz/domain/usecases/retrieve_address.dart';
import 'package:tezos_statz/domain/usecases/store_address.dart';
import 'package:tezos_statz/ui/state/address_notifier.dart';

class MockStoreAddressUsecase extends Mock implements StoreAddressUsecase {}

class MockRetrieveAddressUsecase extends Mock
    implements RetrieveAddressUsecase {}

void main() {
  late MockStoreAddressUsecase mockStoreAddressUsecase;
  late MockRetrieveAddressUsecase mockRetrieveAddressUsecase;

  late AddressNotifier sut;

  setUp(() {
    mockStoreAddressUsecase = MockStoreAddressUsecase();
    mockRetrieveAddressUsecase = MockRetrieveAddressUsecase();
    sut = AddressNotifier(
        storeAddressUsecase: mockStoreAddressUsecase,
        retrieveAddressUsecase: mockRetrieveAddressUsecase);
  });

  group('store address', () {
    test('should not set fields at the beginning', () {
      expect(sut.success, equals(null));
      expect(sut.failure, equals(null));
    });

    test('should call the use case', () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockStoreAddressUsecase.call(address: testAddress))
          .thenAnswer((_) async => const Right(true));

      await sut.store(testAddress);

      verify(() => mockStoreAddressUsecase.call(address: testAddress))
          .called(1);
    });

    test('should notify listeners', () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockStoreAddressUsecase.call(address: testAddress))
          .thenAnswer((_) async => const Right(true));

      var notified = false;
      sut.addListener(() {
        notified = true;
      });

      await sut.store(testAddress);

      expect(notified, equals(true));
    });

    test('should set the success field only on successful call', () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockStoreAddressUsecase.call(address: testAddress))
          .thenAnswer((_) async => const Right(true));

      await sut.store(testAddress);

      expect(sut.success, equals(true));
      expect(sut.failure, equals(null));
    });

    test('should set the failure field only on StorageAccessFailure', () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockStoreAddressUsecase.call(address: testAddress)).thenAnswer(
          (_) async => const Left(
              StorageAccessFailure('The address storage cannot be accessed.')));

      await sut.store(testAddress);

      expect(sut.success, equals(null));
      expect(
          sut.failure,
          equals(const StorageAccessFailure(
              'The address storage cannot be accessed.')));
    });

    test('should set the failure field only on StorageItemStoreFailure',
        () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockStoreAddressUsecase.call(address: testAddress)).thenAnswer(
          (_) async => const Left(StorageItemStoreFailure(
              'The address storage failed to report success.')));

      await sut.store(testAddress);

      expect(sut.success, equals(null));
      expect(
          sut.failure,
          equals(const StorageItemStoreFailure(
              'The address storage failed to report success.')));
    });

    test('should set the failure field only on AddressFormatFailure', () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pn";

      when(() => mockStoreAddressUsecase.call(address: testAddress)).thenAnswer(
          (_) async => const Left(AddressFormatFailure(
              'The address does not have the correct format.')));

      await sut.store(testAddress);

      expect(sut.success, equals(null));
      expect(
          sut.failure,
          equals(const AddressFormatFailure(
              'The address does not have the correct format.')));
    });
  });

  group('retrieve address', () {
    test('should not set fields at the beginning', () {
      expect(sut.addressEntity, null);
      expect(sut.failure, null);
    });

    test('should call the use case', () async {
      const testAddressEntity =
          AddressEntity(address: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk');
      when(() => mockRetrieveAddressUsecase.call())
          .thenAnswer((_) async => const Right(testAddressEntity));

      await sut.retrieve();

      verify(() => mockRetrieveAddressUsecase.call()).called(1);
    });

    test('should notify listeners', () async {
      const testAddressEntity =
          AddressEntity(address: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk');

      when(() => mockRetrieveAddressUsecase.call())
          .thenAnswer((_) async => const Right(testAddressEntity));

      var notified = false;
      sut.addListener(() {
        notified = true;
      });

      await sut.retrieve();

      expect(notified, equals(true));
    });

    test('should set the Entity field only on successful call', () async {
      const testAddressEntity =
          AddressEntity(address: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk');

      when(() => mockRetrieveAddressUsecase.call())
          .thenAnswer((_) async => const Right(testAddressEntity));

      await sut.retrieve();

      expect(sut.addressEntity, equals(testAddressEntity));
      expect(sut.failure, equals(null));
    });

    test('should set the failure field only on StorageAccessFailure', () async {
      when(() => mockRetrieveAddressUsecase.call()).thenAnswer((_) async =>
          const Left(
              StorageAccessFailure('The address storage cannot be accessed.')));

      await sut.retrieve();

      expect(sut.addressEntity, equals(null));
      expect(
          sut.failure,
          equals(const StorageAccessFailure(
              'The address storage cannot be accessed.')));
    });

    test('should set the failure field only on StorageItemRetrieveFailure',
        () async {
      when(() => mockRetrieveAddressUsecase.call()).thenAnswer((_) async =>
          const Left(StorageItemRetrieveFailure(
              'The Address could not be retrieved from storage.')));

      await sut.retrieve();

      expect(sut.addressEntity, equals(null));
      expect(
          sut.failure,
          equals(const StorageItemRetrieveFailure(
              'The Address could not be retrieved from storage.')));
    });
  });
}
