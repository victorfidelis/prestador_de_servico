import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_empty_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/image_card.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/scheduling_detail_state.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/scheduling_detail_viewmodel.dart';
import 'package:provider/provider.dart';

class ServiceImagesView extends StatefulWidget {
  const ServiceImagesView({super.key});

  @override
  State<ServiceImagesView> createState() => _ServiceImagesViewState();
}

class _ServiceImagesViewState extends State<ServiceImagesView> {
  final notifications = CustomNotifications();

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
                              title: 'Imagens',
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
          SliverFillRemaining(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<SchedulingDetailViewModel>().addImageFromGallery,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Consumer<SchedulingDetailViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.state is ServiceImagesLoading) {
            return const Center(child: CustomLoading());
          }

          if (viewModel.state is ServiceImagesError) {
            final errorState = viewModel.state as ServiceImagesError;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              notifications.showSnackBar(context: context, message: errorState.message);
            });
          }

          if (viewModel.state is ServiceImagesLoaded) {
            final state = (viewModel.state as ServiceImagesLoaded);
            if (state.message != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                notifications.showSnackBar(context: context, message: state.message!);
              });
            }
          }

          if (viewModel.scheduling.images.isEmpty) {
            return CustomEmptyList(
              label: 'Nenhuma imagem cadastrada',
              action: viewModel.addImageFromGallery,
              labelAction: 'Adicionar primeira imagem',
            );
          }

          return Wrap(
            children: viewModel.scheduling.images.map((e) => _buildImageCard(e)).toList(),
          );
        },
      ),
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
      confirmCallback: () => context.read<SchedulingDetailViewModel>().removeImage(imageUrl),
    );
  }
}
