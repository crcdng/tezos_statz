import 'package:flutter/foundation.dart';
import 'package:tezos_statz/domain/entities/address_entity.dart';
import 'package:tezos_statz/domain/usecases/retrieve_address.dart';

import '../../common/errors.dart';
import '../../domain/usecases/store_address.dart';

class AddressNotifier with ChangeNotifier {
  final StoreAddressUsecase storeAddressUsecase;
  final RetrieveAddressUsecase retrieveAddressUsecase;
  bool? success;
  AddressEntity? addressEntity;
  Failure? failure;

  AddressNotifier(
      {required this.storeAddressUsecase,
      required this.retrieveAddressUsecase});

  void store(String address) async {
    final result = await storeAddressUsecase(address: address);
    result.fold((failure) {
      this.failure = failure;
    }, (data) {
      success = data;
    });
    notifyListeners();
  }

  void retrieve() async {
    final result = await retrieveAddressUsecase();
    result.fold((failure) {
      this.failure = failure;
    }, (data) {
      addressEntity = data;
    });
    notifyListeners();
  }
}
