import 'package:equatable/equatable.dart';

class AddressEntity with EquatableMixin {
  static const addressStringLength = 36;
  static bool isValidAddress(String? str) {
    return (str != null &&
        str.length == addressStringLength &&
        RegExp(r'^[A-Za-z0-9]+$').hasMatch(str) &&
        (str.startsWith("tz1") ||
            str.startsWith("tz2") ||
            str.startsWith("tz3")));
  }

  final String address;

  const AddressEntity({required this.address});

  @override
  List<Object?> get props => [address];
}
