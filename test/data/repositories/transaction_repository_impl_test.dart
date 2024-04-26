import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/data/datasources/remote_datasource.dart';
import 'package:tezos_statz/data/models/transaction_model.dart';
import 'package:tezos_statz/data/repositories/transaction_repository_impl.dart';
import 'package:tezos_statz/domain/entities/transaction_entity.dart';
import 'package:tezos_statz/domain/repositories/transaction_repository.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late TransactionsRepositoryImpl sut;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    sut = TransactionsRepositoryImpl(datasource: mockRemoteDataSource);
  });

  test('should be a subclass of TransactionsRepository', () {
    expect(sut, isA<TransactionsRepository>());
  });

  group('Retrieve transactions', () {
    test('should return a List of TransactionEntity', () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      const testTransactionModelList = <TransactionModel>[
        TransactionModel(
            time: '2023-06-12T13:52:40Z',
            volume: 0.4125,
            sender: 'KT1WvzYHCNBvDSdwafTHv7nJ1dWmZ8GCYuuC',
            receiver: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk'),
        TransactionModel(
            time: '2023-07-21T21:28:30Z',
            sender: 'KT1Mqx5meQbhufngJnUAGEGpa4ZRxhPSiCgB',
            receiver: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk'),
        TransactionModel(
            time: '2023-07-21T21:28:30Z',
            volume: 1,
            sender: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk',
            receiver: 'tz1KxjakCmqHhSEs1CCw7Uo1d2cnp38WfVmw')
      ];

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

      when(() => mockRemoteDataSource.retrieveTransactions(testAddress))
          .thenAnswer((_) async => testTransactionModelList);

      final result = await sut.retrieve(testAddress);

      // unpack the Either to compare the Lists of Entities
      var listOfEntitiesFromResult;
      result.fold((_) {}, (data) {
        listOfEntitiesFromResult = data;
      });

      // NOTE the comparison does not include the optional volume
      // see Equatable with TransactionEntity
      expect(listEquals(listOfEntitiesFromResult, testTransactionsEntityList),
          true);
    });

    test(
        'should return a ServerFailure when RemoteDataSource reports a ServerException',
        () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockRemoteDataSource.retrieveTransactions(testAddress))
          .thenThrow(ServerException());

      final result = await sut.retrieve(testAddress);

      expect(
          result,
          const Left(ServerFailure(
              'The Server reported an error while retrieving the Transactions.')));
    });
  });
}
