import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_statz/data/models/address_model.dart';
import 'package:tezos_statz/domain/entities/address_entity.dart';

void main() {
  late AddressModel sut;

  const testAddressModel =
      AddressModel(address: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk');

  setUp(() {
    sut = testAddressModel;
  });

  test('should be a subclass of AddressEntity', () {
    expect(sut, isA<AddressEntity>());
  });
}
