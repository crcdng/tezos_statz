import 'package:fpdart/fpdart.dart';
import 'package:tezos_statz/data/datasources/local_storage.dart';
import 'package:tezos_statz/data/models/address_model.dart';

import '../../common/errors.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final LocalStorage storage;

  AddressRepositoryImpl({required this.storage});

  Future<Either<Failure, bool>> storeAddress(String address) async {
    if (!AddressEntity.isValidAddress(address)) {
      return const Left(AddressFormatFailure(
          'The Address does not have the correct format.'));
    }
    try {
      bool result = await storage.storeItem(address);
      return Right(result);
    } on StorageAccessException {
      return const Left(
          StorageAccessFailure('The Storage cannot be accessed.'));
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
