import 'package:fpdart/fpdart.dart';
import 'package:tezos_statz/common/errors.dart';
import 'package:tezos_statz/domain/entities/address_entity.dart';

import '../repositories/address_repository.dart';

class RetrieveAddressUsecase {
  final AddressRepository repository;
  RetrieveAddressUsecase({required this.repository});

  Future<Either<Failure, AddressEntity>> call() {
    return repository.retrieveAddress();
  }
}
