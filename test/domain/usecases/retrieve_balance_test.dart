import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/domain/entities/balance_entity.dart';
import 'package:tezos_statz/domain/repositories/balance_repository.dart';
import 'package:tezos_statz/domain/usecases/retrieve_balance.dart';

class MockBalanceRepository extends Mock implements BalanceRepository {}

const testBalanceEntity = BalanceEntity(amount: 1.02, amountInUsd: 1.33);

const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

void main() {
  late MockBalanceRepository mockBalanceRepository;
  late RetrieveBalanceUsecase sut;

  setUp(() {
    mockBalanceRepository = MockBalanceRepository();
    sut = RetrieveBalanceUsecase(repository: mockBalanceRepository);
  });

  test('should call the repository method', () async {
    when(() => mockBalanceRepository.retrieve(testAddress))
        .thenAnswer((_) async => const Right(testBalanceEntity));

    await sut.call(address: testAddress);

    verify(() => mockBalanceRepository.retrieve(testAddress)).called(1);
  });

  test('should pass the entity', () async {
    when(() => mockBalanceRepository.retrieve(testAddress))
        .thenAnswer((_) async => Right(testBalanceEntity));

    final result = await sut.call(address: testAddress);

    expect(result, const Right(testBalanceEntity));
  });

  test('should pass a failure when the API reports an error', () async {
    when(() => mockBalanceRepository.retrieve(testAddress)).thenAnswer(
        (_) async => const Left(ServerFailure('The API reported an error.')));

    final result = await sut.call(address: testAddress);

    expect(result, const Left(ServerFailure('The API reported an error.')));
  });
}
