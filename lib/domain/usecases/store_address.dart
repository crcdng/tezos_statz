import 'package:fpdart/fpdart.dart';
import 'package:tezos_statz/common/errors.dart';

import '../repositories/address_repository.dart';

class StoreAddressUsecase {
  final AddressRepository repository;
  StoreAddressUsecase({required this.repository});

  Future<Either<Failure, bool>> call({required String address}) {
    return repository.storeAddress(address);
  }
}
