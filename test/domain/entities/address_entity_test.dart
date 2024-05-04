import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_statz/domain/entities/address_entity.dart';

void main() {
  test('AdressEntity should be immutable and comparable', () {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

    expect(
        const AddressEntity(address: testAddress) ==
            const AddressEntity(address: testAddress),
        isTrue);
  });
}
