import 'package:fpdart/fpdart.dart';
import 'package:tezos_statz/domain/entities/balance_entity.dart';
import 'package:tezos_statz/domain/repositories/balance_repository.dart';

import '../../common/errors.dart';

class RetrieveBalanceUsecase {
  final BalanceRepository repository;

  RetrieveBalanceUsecase({required this.repository});

  Future<Either<Failure, BalanceEntity>> call({required String address}) {
    return repository.retrieve(address);
  }
}
