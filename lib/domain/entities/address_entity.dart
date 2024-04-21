import 'package:equatable/equatable.dart';

class AddressEntity with EquatableMixin {
  final String address;

  const AddressEntity({required this.address});

  @override
  List<Object?> get props => [address];
}
