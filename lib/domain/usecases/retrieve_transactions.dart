import 'package:fpdart/fpdart.dart';
import 'package:tezos_statz/domain/entities/transaction_entity.dart';

import '../../common/errors.dart';
import '../repositories/transaction_repository.dart';

class RetrieveTransactionsUsecase {
  final TransactionsRepository repository;

  RetrieveTransactionsUsecase({required this.repository});

  Future<Either<Failure, List<TransactionEntity>>> call(
      {required String address}) {
    return repository.retrieve(address);
  }
}
