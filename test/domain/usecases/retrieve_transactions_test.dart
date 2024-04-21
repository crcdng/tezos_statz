import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/domain/entities/transaction_entity.dart';
import 'package:tezos_statz/domain/repositories/transaction_repository.dart';
import 'package:tezos_statz/domain/usecases/retrieve_transactions.dart';

class MockTransactionRepository extends Mock
    implements TransactionsRepository {}

const testTransactionsEntityList = [
  TransactionEntity(
      time: "2023-06-12T13:52:40Z",
      volume: 0.4125,
      sender: "KT1Mqx5meQbhufngJnUAGEGpa4ZRxhPSiCgB",
      receiver: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk"),
  TransactionEntity(
      time: "2023-07-21T21:28:30Z",
      sender: "KT1Mqx5meQbhufngJnUAGEGpa4ZRxhPSiCgB",
      receiver: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk"),
  TransactionEntity(
      time: "2023-06-12T13:52:40Z",
      volume: 1,
      sender: "tz1KxjakCmqHhSEs1CCw7Uo1d2cnp38WfVmw",
      receiver: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk")
];

const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

void main() {
  late MockTransactionRepository mockTransactionRepository;
  late RetrieveTransactionsUsecase sut;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    sut = RetrieveTransactionsUsecase(repository: mockTransactionRepository);
  });

  test('should call the repository method', () async {
    when(() => mockTransactionRepository.retrieve(testAddress))
        .thenAnswer((_) async => const Right(testTransactionsEntityList));

    await sut.call(address: testAddress);

    verify(() => mockTransactionRepository.retrieve(testAddress)).called(1);
  });

  test('should pass the list of entities', () async {
    when(() => mockTransactionRepository.retrieve(testAddress))
        .thenAnswer((_) async => Right(testTransactionsEntityList));

    final result = await sut.call(address: testAddress);

    expect(result, const Right(testTransactionsEntityList));
  });

  test('should pass a failure when the API reports an error', () async {
    when(() => mockTransactionRepository.retrieve(testAddress)).thenAnswer(
        (_) async => const Left(ServerFailure('The API reported an error.')));

    final result = await sut.call(address: testAddress);

    expect(result, const Left(ServerFailure('The API reported an error.')));
  });
}
