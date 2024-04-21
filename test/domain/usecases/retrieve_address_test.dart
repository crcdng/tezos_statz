import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/domain/entities/address_entity.dart';
import 'package:tezos_statz/domain/repositories/address_repository.dart';
import 'package:tezos_statz/domain/usecases/retrieve_address.dart';

class MockAddressRepository extends Mock implements AddressRepository {}

const testAddressEntity =
    AddressEntity(address: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk');

void main() {
  late MockAddressRepository mockAddressRepository;
  late RetrieveAddressUsecase sut;

  setUp(() {
    mockAddressRepository = MockAddressRepository();
    sut = RetrieveAddressUsecase(repository: mockAddressRepository);
  });

  test('should call the repository method', () async {
    when(() => mockAddressRepository.retrieveAddress())
        .thenAnswer((_) async => const Right(testAddressEntity));

    await sut.call();

    verify(() => mockAddressRepository.retrieveAddress()).called(1);
  });

  test('should pass the entity', () async {
    when(() => mockAddressRepository.retrieveAddress())
        .thenAnswer((_) async => Right(testAddressEntity));

    final result = await sut.call();

    expect(result, const Right(testAddressEntity));
  });

  test('should pass a failure when the API reports an error', () async {
    when(() => mockAddressRepository.retrieveAddress()).thenAnswer((_) async =>
        const Left(StorageItemRetrieveFailure('The API reported an error.')));

    final result = await sut.call();

    expect(result,
        const Left(StorageItemRetrieveFailure('The API reported an error.')));
  });
}
