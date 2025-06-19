
import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/service_images_state.dart';

class ServiceImagesViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;
  final OfflineImageService offlineImageService;
  late String schedulingId;
  List<String> images = [];

  bool _dispose = false;

  ServiceImagesViewModel({
    required this.schedulingService,
    required this.offlineImageService,
  });

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  ServiceImagesState _state = ServiceImagesInitial();
  ServiceImagesState get state => _state;
  void _emitState(ServiceImagesState currentState) {
    _state = currentState;
    if (!_dispose) notifyListeners();
  }

  Future<void> addImageFromGallery() async {
    final eitherPickImage = await offlineImageService.pickImageFromGallery();
    if (eitherPickImage.isLeft) {
      _emitState(ServiceImagesError(eitherPickImage.left!.message));
      return;
    } 
    
    _emitState(ServiceImagesLoading());

    final imageFile = eitherPickImage.right!;
    final addImageEither = await schedulingService.addImage(schedulingId: schedulingId, imageFile: imageFile);
    if (addImageEither.isLeft) {
      _emitState(ServiceImagesError(addImageEither.left!.message));
      return;
    }

    final imageUrl = addImageEither.right!;
    images.add(imageUrl);

    _emitState(ServiceImagesLoaded());
  }

  Future<void> removeImage(String imageUrl) async {
    _emitState(ServiceImagesLoading());

    final removeImageEither = await schedulingService.removeImage(schedulingId: schedulingId, imageUrl: imageUrl);
    if (removeImageEither.isLeft) {
      _emitState(ServiceImagesError(removeImageEither.left!.message));
    }

    images.remove(imageUrl);

    _emitState(ServiceImagesLoaded());
  }
}
