import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/domain/entities/balance_entity.dart';
import 'package:tezos_statz/domain/usecases/retrieve_balance.dart';
import 'package:tezos_statz/ui/state/balance_notifier.dart';
import 'package:mocktail/mocktail.dart';

class MockRetrieveBalanceUsecase extends Mock
    implements RetrieveBalanceUsecase {}

void main() {
  late MockRetrieveBalanceUsecase mockRetrieveBalanceUsecase;

  late BalanceNotifier sut;

  setUp(() {
    mockRetrieveBalanceUsecase = MockRetrieveBalanceUsecase();
    sut = BalanceNotifier(usecase: mockRetrieveBalanceUsecase);
  });

  test('should not set fields at the beginning', () {
    expect(sut.balance, equals(null));
    expect(sut.failure, equals(null));
  });

  test('should call the use case', () async {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
    const testBalanceEntity = BalanceEntity(amount: 1.02, amountInUsd: 1.33);

    when(() => mockRetrieveBalanceUsecase.call(address: testAddress))
        .thenAnswer((_) async => const Right(testBalanceEntity));

    await sut.getBalance(testAddress);

    verify(() => mockRetrieveBalanceUsecase.call(address: testAddress))
        .called(1);
  });

  test('should notify listeners', () async {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
    const testBalanceEntity = BalanceEntity(amount: 1.02, amountInUsd: 1.33);

    when(() => mockRetrieveBalanceUsecase.call(address: testAddress))
        .thenAnswer((_) async => const Right(testBalanceEntity));

    var notified = false;
    sut.addListener(() {
      notified = true;
    });

    await sut.getBalance(testAddress);

    expect(notified, equals(true));
  });

  test('should set the balance field only on successful call', () async {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
    const testBalanceEntity = BalanceEntity(amount: 1.02, amountInUsd: 1.33);

    when(() => mockRetrieveBalanceUsecase.call(address: testAddress))
        .thenAnswer((_) async => const Right(testBalanceEntity));

    await sut.getBalance(testAddress);

    expect(sut.balance, equals(testBalanceEntity));
    expect(sut.failure, equals(null));
  });

  test('should set the failure field only on StorageAccessFailure', () async {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

    when(() => mockRetrieveBalanceUsecase.call(address: testAddress))
        .thenAnswer((_) async => const Left(ServerFailure(
            'The Server reported an error while retrieving the Balance.')));

    await sut.getBalance(testAddress);

    expect(sut.balance, equals(null));
    expect(
        sut.failure,
        equals(const ServerFailure(
            'The Server reported an error while retrieving the Balance.')));
  });
}
