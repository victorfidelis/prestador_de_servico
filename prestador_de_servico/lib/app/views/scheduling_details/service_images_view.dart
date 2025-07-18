import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_empty_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/image_card.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/scheduling_detail_viewmodel.dart';
import 'package:provider/provider.dart';

class ServiceImagesView extends StatefulWidget {
  const ServiceImagesView({super.key});

  @override
  State<ServiceImagesView> createState() => _ServiceImagesViewState();
}

class _ServiceImagesViewState extends State<ServiceImagesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverFloatingHeader(child: CustomHeader(title: 'Imagens')),
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Consumer<SchedulingDetailViewModel>(
                  builder: (context, viewModel, _) {
                    if (viewModel.imagesLoading) {
                      return const Center(child: CustomLoading());
                    }

                    if (viewModel.scheduling.images.isEmpty) {
                      return CustomEmptyList(
                        label: 'Nenhuma imagem cadastrada',
                        action: viewModel.addImageFromGallery,
                        labelAction: 'Adicionar primeira imagem',
                      );
                    }

                    return Wrap(
                      children: viewModel.scheduling.images.map(
                        (e) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: ImageCard(
                              imageUrl: e,
                              onLongPress: () => _onRemoveImage(e),
                            ),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<SchedulingDetailViewModel>().addImageFromGallery,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onRemoveImage(String imageUrl) {
    CustomNotifications().showQuestionAlert(
      context: context,
      title: 'Excluir imagem',
      content: 'Tem certeza que deseja excluir a imagem?',
      confirmCallback: () => context.read<SchedulingDetailViewModel>().removeImageFromServiceimagesView(imageUrl),
    );
  }
}
