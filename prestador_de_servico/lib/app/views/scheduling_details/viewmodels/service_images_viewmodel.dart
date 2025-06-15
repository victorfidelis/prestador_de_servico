
import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/service_images_state.dart';

class ServiceImagesViewModel extends ChangeNotifier {
  final SchedulingService schedulingService;
  final OfflineImageService offlineImageService;
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

  Future<void> pickImageFromGallery() async {
    final eitherPickImage = await offlineImageService.pickImageFromGallery();
    if (eitherPickImage.isLeft) {
      _emitState(PickImageError(eitherPickImage.left!.message));
    } else {
      _emitState(PickImageSuccess(eitherPickImage.right!));
    }
  }
}
