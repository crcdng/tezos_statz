import 'package:fpdart/fpdart.dart';

import '../../common/errors.dart';
import '../entities/balance_entity.dart';

abstract class BalanceRepository {
  Future<Either<Failure, BalanceEntity>> retrieve(String address);
}
