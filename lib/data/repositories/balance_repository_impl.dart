import 'package:fpdart/fpdart.dart';
import 'package:tezos_statz/data/datasources/remote_datasource.dart';
import 'package:tezos_statz/domain/repositories/balance_repository.dart';
import '../../common/errors.dart';
import '../../domain/entities/balance_entity.dart';
import '../models/balance_model.dart';

class BalanceRepositoryImpl implements BalanceRepository {
  final RemoteDataSource datasource;

  BalanceRepositoryImpl({required this.datasource});

  Future<Either<Failure, BalanceEntity>> retrieve(String address) async {
    try {
      BalanceModel result = await datasource.retrieveBalance(address);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(
          'The Server reported an error while retrieving the Balance.'));
    }
  }
}
