import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/domain/entities/address_entity.dart';
import 'package:tezos_statz/domain/repositories/address_repository.dart';
import 'package:tezos_statz/domain/usecases/store_address.dart';

class MockAddressRepository extends Mock implements AddressRepository {}

final testAddressEntity =
    AddressEntity(address: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk");

void main() {
  late MockAddressRepository mockAddressRepository;
  late StoreAddressUsecase sut;

  setUp(() {
    mockAddressRepository = MockAddressRepository();
    sut = StoreAddressUsecase(repository: mockAddressRepository);
  });

  // TODO this test fails -> refactor the isValidAddress method
  test('should call isValidAddress', () async {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

    when(() => mockAddressRepository.storeAddress(testAddress))
        .thenAnswer((_) async => Right(true));

    await sut.call(address: testAddress);

    verify(() => mockAddressRepository.isValidAddress(testAddress)).called(1);
  });

  test('should call the repository method', () async {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

    when(() => mockAddressRepository.storeAddress(testAddress))
        .thenAnswer((_) async => Right(true));

    await sut.call(address: testAddress);

    verify(() => mockAddressRepository.storeAddress(testAddress)).called(1);
  });

  // NOTE use case returns a Future<Either<Failure, bool>>
  test('should pass true when storage succeeds', () async {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

    when(() => mockAddressRepository.storeAddress(testAddress))
        .thenAnswer((_) async => Right(true));

    final result = await sut.call(address: testAddress);

    expect(result, const Right(true));
  });

  test('should pass a failure when the API reports an error', () async {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

    when(() => mockAddressRepository.storeAddress(testAddress)).thenAnswer(
        (_) async => const Left(
            StorageAccessFailure('The Storage cannot be accessed.')));

    final result = await sut.call(address: testAddress);

    expect(result,
        const Left(StorageAccessFailure('The Storage cannot be accessed.')));
  });
}
