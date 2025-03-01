import 'package:prestador_de_servico/app/models/address/address.dart';

class AddressConverter {
  static Address fromMap({required Map map}) {
    return Address(
      city: map['city'],
      complement: map['complement'],
      neighborhood: map['neighborhood'],
      number: map['number'],
      state: map['state'],
      street: map['street'],
      zipCode: map['zipCode'],
    );
  }
}
