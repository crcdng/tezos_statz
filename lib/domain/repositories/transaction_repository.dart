import 'package:fpdart/fpdart.dart';

import '../../common/errors.dart';
import '../entities/transaction_entity.dart';

abstract class TransactionsRepository {
  Future<Either<Failure, List<TransactionEntity>>> retrieve(String address);
}
