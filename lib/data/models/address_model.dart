import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({required super.address});

  AddressEntity toEntity() => AddressEntity(address: address);

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(address: entity.address);
  }
}
