import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/data/datasources/remote_datasource.dart';
import 'package:tezos_statz/data/models/balance_model.dart';
import 'package:tezos_statz/data/repositories/balance_repository_impl.dart';
import 'package:tezos_statz/domain/entities/balance_entity.dart';
import 'package:tezos_statz/domain/repositories/balance_repository.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late BalanceRepositoryImpl sut;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    sut = BalanceRepositoryImpl(datasource: mockRemoteDataSource);
  });

  test('should be a subclass of BalanceRepository', () {
    expect(sut, isA<BalanceRepository>());
  });

  group('Retrieve balance', () {
    test('should return a BalanceEntity', () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockRemoteDataSource.retrieveBalance(testAddress))
          .thenAnswer((_) async => BalanceModel(amount: 1.0, amountInUsd: 1.0));

      final result = await sut.retrieve(testAddress);

      expect(result, Right(BalanceEntity(amount: 1.0, amountInUsd: 1.0)));
    });

    test(
        'should return a ServerFailure when RemoteDataSource throws a ServerException',
        () async {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      when(() => mockRemoteDataSource.retrieveBalance(testAddress))
          .thenThrow(ServerException());

      final result = await sut.retrieve(testAddress);

      expect(
          result,
          const Left(ServerFailure(
              'The Server reported an error while retrieving the Balance.')));
    });
  });
}
