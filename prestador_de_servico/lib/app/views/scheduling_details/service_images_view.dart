import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_empty_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/service_images_viewmodel.dart';
import 'package:provider/provider.dart';

class ServiceImagesView extends StatefulWidget {
  final Scheduling scheduling;
  const ServiceImagesView({super.key, required this.scheduling});

  @override
  State<ServiceImagesView> createState() => _ServiceImagesViewState();
}

class _ServiceImagesViewState extends State<ServiceImagesView> {
  late ServiceImagesViewModel serviceImagesViewModel;

  @override
  void initState() {
    serviceImagesViewModel = ServiceImagesViewModel(
      schedulingService: context.read<SchedulingService>(),
      offlineImageService: context.read<OfflineImageService>(),
    );
    serviceImagesViewModel.schedulingId = widget.scheduling.id;
    serviceImagesViewModel.images = widget.scheduling.images;
    super.initState();
  }

  @override
  void dispose() {
    serviceImagesViewModel.dispose();
    super.dispose();
  }

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
          SliverFillRemaining(child: _buildBody())
        ],
      ),
    );
  }

  Widget _buildBody() {
    return CustomEmptyList(
      label: 'Nenhuma imagem cadastrada',
      action: serviceImagesViewModel.pickImageFromGallery,
      labelAction: 'Adicionar primeira imagem',
    );

    // return const Column(
    //   children: [
    //     ImageCard(defaultFileImage: 'assets/images/adicionar_imagem.jpg'),
    //   ],
    // );
  }
}
