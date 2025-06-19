import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/viewmodels/scheduling/scheduling_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_empty_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/image_card.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/service_images_state.dart';
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
  final notifications = CustomNotifications();

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
          SliverFillRemaining(
            child: ListenableBuilder(
                listenable: serviceImagesViewModel,
                builder: (context, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildBody(),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: serviceImagesViewModel.addImageFromGallery,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (serviceImagesViewModel.state is ServiceImagesLoading) {
      return const Center(child: CustomLoading());
    }

    if (serviceImagesViewModel.state is ServiceImagesError) {
      final errorState = serviceImagesViewModel.state as ServiceImagesError;
      return Center(child: Text(errorState.message));
    }

    if (serviceImagesViewModel.images.isEmpty) {
      return CustomEmptyList(
        label: 'Nenhuma imagem cadastrada',
        action: serviceImagesViewModel.addImageFromGallery,
        labelAction: 'Adicionar primeira imagem',
      );
    }

    return Wrap(
      children: serviceImagesViewModel.images.map((e) => _buildImageCard(e)).toList(),
    );
  }

  Widget _buildImageCard(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ImageCard(
        imageUrl: imageUrl,
        onLongPress: () => _onRemoveImage(imageUrl),
      ),
    );
  }

  void _onRemoveImage(String imageUrl) {
    notifications.showQuestionAlert(
      context: context,
      title: 'Excluir imagem',
      content: 'Tem certeza que deseja excluir a imagem?',
      confirmCallback: () => serviceImagesViewModel.removeImage(imageUrl),
    );
  }
}
