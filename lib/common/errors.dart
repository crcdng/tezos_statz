abstract class Failure {
  final String message;
  const Failure(this.message);
}

class StorageItemRetrieveFailure extends Failure {
  const StorageItemRetrieveFailure(super.message);
}

class StorageItemStoreFailure extends Failure {
  const StorageItemStoreFailure(super.message);
}

class AddressFormatFailure extends Failure {
  const AddressFormatFailure(super.message);
}

class StorageAccessFailure extends Failure {
  const StorageAccessFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ServerException implements Exception {}

class StorageItemNotFoundException implements Exception {}

class StorageAccessException implements Exception {}
