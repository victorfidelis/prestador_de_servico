import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/image_card.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';

class ServiceImagesView extends StatefulWidget {
  const ServiceImagesView({super.key});

  @override
  State<ServiceImagesView> createState() => _ServiceImagesViewState();
}

class _ServiceImagesViewState extends State<ServiceImagesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            floating: true,
            delegate: SliverAppBarDelegate(
              minHeight: 120,
              maxHeight: 120,
              child: Stack(
                children: [
                  CustomHeaderContainer(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            child: BackNavigation(
                              onTap: () => Navigator.pop(context),
                            ),
                          ),
                          const Expanded(
                            child: CustomAppBarTitle(
                              title: 'Agendamento',
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildBody())
        ],
      ),
    );
  }

  Widget _buildBody() {
    return const Column(
      children: [
        ImageCard(defaultFileImage: 'assets/images/adicionar_imagem.jpg'),
      ],
    );
  }
}
