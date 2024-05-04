import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
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

  group('store address', () async {
    test('should not set fields at the beginning', () {
      expect(sut.success, null);
      expect(sut.failure, null);
    });

    test('should call the use case', () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockStoreAddressUsecase.call(address: testAddress))
          .thenAnswer((_) async => const Right(true));

      await sut.store(testAddress);

      verify(() => mockStoreAddressUsecase.call(address: testAddress))
          .called(1);
    });
  });

  group('retrieve address', () {
    test('should not set fields at the beginning', () async {
      expect(sut.addressEntity, null);
      expect(sut.failure, null);
    });
  });
}
