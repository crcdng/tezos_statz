import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/domain/entities/transaction_entity.dart';
import 'package:tezos_statz/domain/usecases/retrieve_transactions.dart';
import 'package:tezos_statz/ui/state/transactions_notifier.dart';

class MockRetrieveTransactionsUsecase extends Mock
    implements RetrieveTransactionsUsecase {}

void main() {
  late MockRetrieveTransactionsUsecase mockRetrieveTransactionsUsecase;

  late TransactionsNotifier sut;

  setUp(() {
    mockRetrieveTransactionsUsecase = MockRetrieveTransactionsUsecase();
    sut = TransactionsNotifier(usecase: mockRetrieveTransactionsUsecase);
  });

  test('should not set fields at the beginning', () {
    expect(sut.transactions, equals(null));
    expect(sut.failure, equals(null));
  });

  test('should call the use case', () async {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
    const testTransactionsEntityList = <TransactionEntity>[
      TransactionEntity(
          time: "2023-06-12T13:52:40Z",
          volume: 0.4125,
          sender: "KT1WvzYHCNBvDSdwafTHv7nJ1dWmZ8GCYuuC",
          receiver: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk"),
      TransactionEntity(
          time: "2023-07-21T21:28:30Z",
          sender: "KT1Mqx5meQbhufngJnUAGEGpa4ZRxhPSiCgB",
          receiver: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk"),
      TransactionEntity(
          time: "2023-07-21T21:28:30Z",
          volume: 1,
          sender: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk",
          receiver: "tz1KxjakCmqHhSEs1CCw7Uo1d2cnp38WfVmw")
    ];

    when(() => mockRetrieveTransactionsUsecase.call(address: testAddress))
        .thenAnswer((_) async => const Right(testTransactionsEntityList));

    await sut.getTransactions(testAddress);

    verify(() => mockRetrieveTransactionsUsecase.call(address: testAddress))
        .called(1);
  });

  test('should notify listeners', () async {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
    const testTransactionsEntityList = <TransactionEntity>[
      TransactionEntity(
          time: "2023-06-12T13:52:40Z",
          volume: 0.4125,
          sender: "KT1WvzYHCNBvDSdwafTHv7nJ1dWmZ8GCYuuC",
          receiver: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk"),
      TransactionEntity(
          time: "2023-07-21T21:28:30Z",
          sender: "KT1Mqx5meQbhufngJnUAGEGpa4ZRxhPSiCgB",
          receiver: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk"),
      TransactionEntity(
          time: "2023-07-21T21:28:30Z",
          volume: 1,
          sender: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk",
          receiver: "tz1KxjakCmqHhSEs1CCw7Uo1d2cnp38WfVmw")
    ];

    when(() => mockRetrieveTransactionsUsecase.call(address: testAddress))
        .thenAnswer((_) async => const Right(testTransactionsEntityList));

    var notified = false;
    sut.addListener(() {
      notified = true;
    });

    await sut.getTransactions(testAddress);

    expect(notified, equals(true));
  });

  test('should set the transactrions field only on successful call', () async {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
    const testTransactionsEntityList = <TransactionEntity>[
      TransactionEntity(
          time: "2023-06-12T13:52:40Z",
          volume: 0.4125,
          sender: "KT1WvzYHCNBvDSdwafTHv7nJ1dWmZ8GCYuuC",
          receiver: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk"),
      TransactionEntity(
          time: "2023-07-21T21:28:30Z",
          sender: "KT1Mqx5meQbhufngJnUAGEGpa4ZRxhPSiCgB",
          receiver: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk"),
      TransactionEntity(
          time: "2023-07-21T21:28:30Z",
          volume: 1,
          sender: "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk",
          receiver: "tz1KxjakCmqHhSEs1CCw7Uo1d2cnp38WfVmw")
    ];

    when(() => mockRetrieveTransactionsUsecase.call(address: testAddress))
        .thenAnswer((_) async => const Right(testTransactionsEntityList));

    await sut.getTransactions(testAddress);

    expect(sut.transactions, equals(testTransactionsEntityList));
    expect(sut.failure, equals(null));
  });

  test('should set the failure field only on StorageAccessFailure', () async {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

    when(() => mockRetrieveTransactionsUsecase.call(
        address:
            testAddress)).thenAnswer((_) async => const Left(ServerFailure(
        'The Server reported an error while retrieving the Transactions.')));

    await sut.getTransactions(testAddress);

    expect(sut.transactions, equals(null));
    expect(
        sut.failure,
        equals(const ServerFailure(
            'The Server reported an error while retrieving the Transactions.')));
  });
}
