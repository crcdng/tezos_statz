import 'package:fpdart/fpdart.dart';
import '../../common/errors.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/remote_datasource.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  final RemoteDataSource datasource;

  TransactionsRepositoryImpl({required this.datasource});

  Future<Either<Failure, List<TransactionEntity>>> retrieve(
      String address) async {
    try {
      final results = await datasource.retrieveTransactions(address);
      return Right(results.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(
          'The Server reported an error while retrieving the Transactions.'));
    }
  }
}
