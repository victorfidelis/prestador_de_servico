import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/address/address.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/address_card.dart';

class SchedulingAddress extends StatelessWidget {
  final Address? address;
  const SchedulingAddress({super.key, this.address});

  @override
  Widget build(BuildContext context) {
    if (address == null) {
      return const Padding(
        padding: EdgeInsets.only(left: 20, top: 8, right: 20),
        child: Text('Local não informado'),
      );
    }
    return Padding(
        padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
      child: AddressCard(address: address!),
    );
  }
}