import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/animated_collections_helpers/animated_list_helper.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/scheduling_detail_state.dart';

class SchedulingDetailViewModel extends ChangeNotifier {
  Scheduling scheduling;
  SchedulingService schedulingService;
  final OfflineImageService offlineImageService;
  bool hasChange = false;
  bool _dispose = false;
  AnimatedListHelper<String>? imageListHelper;

  SchedulingDetailViewModel({
    required this.scheduling,
    required this.schedulingService,
    required this.offlineImageService,
  });

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  SchedulingDetailState _state = SchedulingDetailInitial();
  SchedulingDetailState get state => _state;
  void _emitState(SchedulingDetailState currentState) {
    _state = currentState;
    if (!_dispose) notifyListeners();
  }
  
  void _changeState(SchedulingDetailState currentState) {
    _state = currentState;
  }

  void initServiceImageState() {
    _changeState(ServiceImagesLoaded());
  }

  void returnToSchedulingDetail() {
    _emitState(SchedulingDetailLoaded());
  }

  Future<void> onChangeScheduling() async {
    hasChange = true;
    await refreshScheduling();
  } 

  Future<void> refreshScheduling() async {
    _emitState(SchedulingDetailLoading());

    final getEither =
        await schedulingService.getScheduling(schedulingId: scheduling.id);

    if (getEither.isLeft) {
      _emitState(SchedulingDetailError(message: getEither.left!.message));
    } else {
      scheduling = getEither.right!;
      _emitState(SchedulingDetailLoaded());
    }
  }

  Future<void> confirmScheduling() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.confirmScheduling(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshScheduling();
    }
  }

  Future<void> denyScheduling() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.denyScheduling(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshScheduling();
    }
  }

  Future<void> requestChangeScheduling() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.requestChangeScheduling(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshScheduling();
    }
  }

  Future<void> cancelScheduling() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.cancelScheduling(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshScheduling();
    }
  }

  Future<void> schedulingInService() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.schedulingInService(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshScheduling();
    }
  }

  Future<void> performScheduling() async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.performScheduling(schedulingId: scheduling.id);

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      hasChange = true;
      await refreshScheduling();
    }
  }

  Future<void> reviewScheduling({
    required int review,
    required String reviewDetails,
  }) async {
    _emitState(SchedulingDetailLoading());
    final either = await schedulingService.addOrEditReview(
      schedulingId: scheduling.id,
      review: review,
      reviewDetails: reviewDetails,
    );

    if (either.isLeft) {
      _emitState(SchedulingDetailError(message: either.left!.message));
    } else {
      await refreshScheduling();
    }
  } 

  void setImageListHelper(AnimatedListHelper<String> value) {
    imageListHelper = value;
  }

  void setToImageView() {
    _changeState(ServiceImagesLoaded());
  }

  void setToSchedulingDetailView() {
    _emitState(SchedulingDetailLoaded());
  }

  Future<void> addImageFromGallery() async {
    final eitherPickImage = await offlineImageService.pickImageFromGallery();
    if (eitherPickImage.isLeft) {
      _emitState(ServiceImagesError(message: eitherPickImage.left!.message));
      return;
    } 
    
    _emitState(ServiceImagesLoading());

    final imageFile = eitherPickImage.right!;
    final addImageEither = await schedulingService.addImage(schedulingId: scheduling.id, imageFile: imageFile);
    if (addImageEither.isLeft) {
      _emitState(ServiceImagesError(message: addImageEither.left!.message));
      return;
    }

    final imageUrl = addImageEither.right!;
    scheduling.images.add(imageUrl);
    imageListHelper!.insert(imageUrl);

    _emitState(ServiceImagesLoaded());
  }

  Future<void> removeImage(String imageUrl) async {
    final index = scheduling.images.indexWhere((i) => i == imageUrl);
    imageListHelper!.removeAt(index);
    scheduling.images.remove(imageUrl);

    final removeImageEither = await schedulingService.removeImage(schedulingId: scheduling.id, imageUrl: imageUrl);
    if (removeImageEither.isLeft) {
      _emitState(ServiceImagesError(message: removeImageEither.left!.message));
    }
  }
}
