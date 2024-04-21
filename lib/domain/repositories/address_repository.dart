import 'package:fpdart/fpdart.dart';
import '../../common/errors.dart';
import '../entities/address_entity.dart';

abstract class AddressRepository {
  Future<Either<Failure, bool>> storeAddress(String address);
  Future<Either<Failure, AddressEntity>> retrieveAddress();
}
