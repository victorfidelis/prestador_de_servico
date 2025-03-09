import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/address/address.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:replace_diacritic/replace_diacritic.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressCard extends StatefulWidget {
  final Address address;
  const AddressCard({super.key, required this.address});

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  late Address address;
  final CustomNotifications notifications = CustomNotifications();

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
            CustomLink(label: 'Abrir no maps', onTap: openUrl)
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

  Future<void> openUrl() async {
    var textUrl =
        'https://www.google.com/maps/place/${address.street.trim()},+${address.number.trim()},+${Formatters.formatZipCode(address.zipCode)}';
    textUrl = textUrl.replaceAll(' ', '+');
    textUrl = replaceDiacritic(textUrl);
    final uri = Uri.parse(textUrl);
    if (!await launchUrl(uri)) {
      throw Exception('Houve uma falha ao abrir a url $textUrl');
    }
  }
}
