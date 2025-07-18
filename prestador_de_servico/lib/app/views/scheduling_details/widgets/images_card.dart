import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/animated_horizontal_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/shared/widgets/image_card.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/scheduling_detail_viewmodel.dart';
import 'package:provider/provider.dart';

class ImagesCard extends StatefulWidget {
  const ImagesCard({super.key});

  @override
  State<ImagesCard> createState() => _ImagesCardState();
}

class _ImagesCardState extends State<ImagesCard> {
  final _scrollController = ScrollController();
  final notifications = CustomNotifications();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SchedulingDetailViewModel>(builder: (context, viewModel, _) {

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Imagens',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                CustomLink(label: 'Abrir', onTap: _onOpenAllImages),
              ],
            ),
          ),
          const SizedBox(height: 12),
          viewModel.scheduling.images.isEmpty ? _buildEmptyListImages() : const SizedBox(),
          AnimatedHorizontalList<String>(
            initialItems: viewModel.scheduling.images,
            scrollController: _scrollController,
            itemBuilder: (context, image, index, animation) {
              return Padding(
                key: ValueKey(image),
                padding: const EdgeInsets.all(8),
                child: ImageCard(imageUrl: image, onLongPress: () => _onRemoveImage(image)),
              );
            },
            removedItemBuilder: (
              String image,
              BuildContext context,
              Animation<double> animation,
            ) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: ImageCard(
                  imageUrl: image,
                ),
              );
            },
            onListHelperReady: viewModel.setImageListHelper,
            listHeight: viewModel.scheduling.images.isEmpty ? 0 : 190,
            firstItemPadding: 20,
            lastItemPadding: 190,
          ),
        ],
      );
    });
  }

  Widget _buildEmptyListImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Nenhuma imagem cadastrada',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.shadow,
          ),
        ),
      ],
    );
  }

  void _onOpenAllImages() async {
    await Navigator.pushNamed(context, '/serviceImages',
        arguments: {'provider': context.read<SchedulingDetailViewModel>()});
  }

  void _onRemoveImage(String imageUrl) {
    notifications.showQuestionAlert(
      context: context,
      title: 'Excluir imagem',
      content: 'Tem certeza que deseja excluir a imagem?',
      confirmCallback: () {
        context.read<SchedulingDetailViewModel>().removeImage(imageUrl);
      },
    );
  }
}
