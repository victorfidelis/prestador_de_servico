import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/address/address.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';

class AddressCard extends StatefulWidget {
  final Address address;
  const AddressCard({super.key, required this.address});

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  late Address address;

  @override
  void initState() {
    address = widget.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formatZipCode = Formatters.formatZipCode(address.zipCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Local',
                style: TextStyle(fontSize: 16),
              ),
            ),
            CustomLink(label: 'Abrir no maps', onTap: () {})
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cep: $formatZipCode',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                '${address.street}, ${address.number}',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                address.neighborhood,
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                '${address.city}, ${address.state}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
