import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_statz/data/storage.dart';
import 'package:tezos_statz/model/address.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Address sut;
  late MockStorage mockStorage;

  setUp(() {
    mockStorage = MockStorage();
    sut = Address(mockStorage);
  });

  group('address', () {
    test('store address', () {
      fail("not implemented");
    });

    test('retrieve address', () {
      fail("not implemented");
    });
  });
}
