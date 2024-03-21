import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/data/tezos_api.dart';
import 'package:tezos_statz/model/balance.dart';

class MockApi extends Mock implements TezosApi {}

void main() {
  late Balance sut;
  late MockApi mockApi;

  setUp(() {
    mockApi = MockApi();
    sut = Balance(mockApi);
  });

  group('address', () {
    test('retrieve balance for address', () {
      fail("not implemented");
    });
  });
}
