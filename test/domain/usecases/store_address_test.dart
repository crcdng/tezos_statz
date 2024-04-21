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

  test('should call the repository method', () async {
    when(() => mockAddressRepository
            .storeAddress('tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk'))
        .thenAnswer((_) async => Right(true));

    await sut.call(address: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk');

    verify(() => mockAddressRepository
        .storeAddress('tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk')).called(1);
  });

  // NOTE use case returns a Future<Either<Failure, bool>>
  test('should pass true when storage succeeds', () async {
    when(() => mockAddressRepository
            .storeAddress('tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk'))
        .thenAnswer((_) async => Right(true));

    final result =
        await sut.call(address: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk');

    expect(result, const Right(true));
  });

  test('should pass a failure when the API reports an error', () async {
    when(() =>
        mockAddressRepository.storeAddress(
            'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk')).thenAnswer((_) async =>
        const Left(StorageAccessFailure('The Storage cannot be accessed.')));

    final result =
        await sut.call(address: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk');

    expect(result,
        const Left(StorageAccessFailure('The Storage cannot be accessed.')));
  });
}
