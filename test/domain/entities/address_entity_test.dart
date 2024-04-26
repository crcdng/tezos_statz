import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_statz/domain/entities/address_entity.dart';

// NOTE the AdressEntity has additional unit tests because it contains a static method in order to check if the address is valid
// TBD if the entity should stay a "pure data class" that method and these tests could be moved into the repository implementation
// the tests here check if the address format (syntax) is valid, not if the address actually exists

void main() {
  group('Immutable and comparable entity', () {
    const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

    test('AdressEntity should be immutable and comparable', () {
      expect(
          const AddressEntity(address: testAddress) ==
              const AddressEntity(address: testAddress),
          isTrue);
    });
  });
  group('Validating Tezos address format', () {
    test('Valid address starting with tz1 should pass as valid', () {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      final result = AddressEntity.isValidAddress(testAddress);
      expect(result, true);
    });

    test('Valid address starting with tz2 should pass as valid', () {
      const testAddress = "tz2ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      final result = AddressEntity.isValidAddress(testAddress);
      expect(result, true);
    });
    test('Valid address starting with tz3 should pass as valid', () {
      const testAddress = "tz3ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";

      final result = AddressEntity.isValidAddress(testAddress);
      expect(result, true);
    });
    test('Too short address should return invalid', () {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pn";

      final result = AddressEntity.isValidAddress(testAddress);
      expect(result, false);
    });
    test('Too long address should return invalid', () {
      const testAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnkd";
      final result = AddressEntity.isValidAddress(testAddress);

      expect(result, false);
    });
    test('address with incorrect prefix should return invalid', () {
      const testAddress = "tz4ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pn";

      final result = AddressEntity.isValidAddress(testAddress);
      expect(result, false);
    });
    test('address containing special character should return invalid', () {
      const testAddress = "tz1ffYDwFHchNy5vA😀isuCAK2yVxh4Ye9pnk";

      final result = AddressEntity.isValidAddress(testAddress);
      expect(result, false);
    });
    test('empty string should return invalid', () {
      const testAddress = "";

      final result = AddressEntity.isValidAddress(testAddress);
      expect(result, false);
    });
    test('null should return invalid', () {
      const testAddress = null;

      final result = AddressEntity.isValidAddress(testAddress);
      expect(result, false);
    });
  });
}
