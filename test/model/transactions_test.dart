import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/data/tezos_api.dart';
import 'package:tezos_statz/model/transactions.dart';

class MockApi extends Mock implements TezosApi {}

void main() {
  late MockApi mockApi;
  late Transactions sut;

  setUp(() {
    mockApi = MockApi();
    sut = Transactions(mockApi);
  });

  group('transactions', () {
    test('receive transactions for address', () {
      fail("not implemented");
    });
  });
}
