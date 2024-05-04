import 'package:fpdart/fpdart.dart';
import 'package:tezos_statz/data/datasources/local_storage.dart';
import 'package:tezos_statz/data/models/address_model.dart';

import '../../common/errors.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final LocalStorage storage;

  AddressRepositoryImpl({required this.storage});

  bool isValidAddress(address) {
    // NOTE TODO static cling, depends on global method
    // inject validation function in constructor
    return AddressEntity.isValidAddress(address);
  }

  Future<Either<Failure, bool>> storeAddress(String address) async {
    if (!isValidAddress(address)) {
      return const Left(AddressFormatFailure(
          'The address does not have the correct format.'));
    }
    try {
      bool result = await storage.storeItem(address);
      if (result) {
        return Right(result);
      } else {
        return const Left(StorageItemStoreFailure(
            'The address storage failed to report success.'));
      }
    } on StorageAccessException {
      return const Left(
          StorageAccessFailure('The address storage cannot be accessed.'));
    }
  }

  Future<Either<Failure, AddressEntity>> retrieveAddress() async {
    try {
      AddressModel result = await storage.retrieveItem();
      return Right(result.toEntity());
    } on StorageItemNotFoundException {
      return const Left(StorageItemRetrieveFailure(
          'The Address could not be retrieved from storage.'));
    }
  }
}
