import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/search_text_field.dart';

class ServiceView extends StatelessWidget {
  const ServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomHeaderContainer(
            height: 110,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 14, 50, 10),
                  child: const CustomAppBarTitle(title: 'Serviços'),
                ),
                BackNavigation(onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 88),
            child: SearchTextField(
              hintText: 'Pesquise por um serviço ou categoria',
              onChanged: (String value) {},
            ),
          ),
        ],
      ),
    );
  }
}
