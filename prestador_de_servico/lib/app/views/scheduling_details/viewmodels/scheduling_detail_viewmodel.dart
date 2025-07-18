import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/animated_collections_helpers/animated_list_helper.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';

class SchedulingDetailViewModel extends ChangeNotifier {
  Scheduling scheduling;
  SchedulingService schedulingService;
  final OfflineImageService offlineImageService;
  bool hasChange = false;
  AnimatedListHelper<String>? imageListHelper;

  bool schedulingLoading = false;
  bool imagesLoading = false;
  ValueNotifier<String?> notificationMessage = ValueNotifier(null);

  String? schedulingErrorMessage;

  SchedulingDetailViewModel({
    required this.scheduling,
    required this.schedulingService,
    required this.offlineImageService,
  });

  bool get hasSchedulingError => schedulingErrorMessage != null;

  void _setSchedulingLoading(bool value) {
    schedulingLoading = value;
    notifyListeners();
  }

  void _setImagesLoading(bool value) {
    imagesLoading = value;
    notifyListeners();
  }

  void _setNotificationMessage(String value) {
    notificationMessage.value = null; // Reset to ensure listeners are notified
    notificationMessage.value = value;
  }

  void setImageListHelper(AnimatedListHelper<String> value) {
    imageListHelper = value;
  }

  Future<void> onChangeScheduling() async {
    hasChange = true;
    await refreshScheduling();
  }

  Future<void> refreshScheduling() async {
    _clearErrors();
    _setSchedulingLoading(true);

    final getEither = await schedulingService.getScheduling(schedulingId: scheduling.id);

    if (getEither.isLeft) {
      schedulingErrorMessage = getEither.left!.message;
    } else {
      scheduling = getEither.right!;
      ;
    }

    _setSchedulingLoading(false);
  }

  Future<void> confirmScheduling() async {
    _setSchedulingLoading(true);

    final either = await schedulingService.confirmScheduling(schedulingId: scheduling.id);
    if (either.isLeft) {
      schedulingErrorMessage = either.left!.message;
    } else {
      hasChange = true;
      await refreshScheduling();
    }

    _setSchedulingLoading(false);
  }

  Future<void> denyScheduling() async {
    _setSchedulingLoading(true);

    final either = await schedulingService.denyScheduling(schedulingId: scheduling.id);
    if (either.isLeft) {
      schedulingErrorMessage = either.left!.message;
    } else {
      hasChange = true;
      await refreshScheduling();
    }

    _setSchedulingLoading(false);
  }

  Future<void> requestChangeScheduling() async {
    _setSchedulingLoading(true);

    final either = await schedulingService.requestChangeScheduling(schedulingId: scheduling.id);
    if (either.isLeft) {
      schedulingErrorMessage = either.left!.message;
    } else {
      hasChange = true;
      await refreshScheduling();
    }

    _setSchedulingLoading(false);
  }

  Future<void> cancelScheduling() async {
    _setSchedulingLoading(true);

    final either = await schedulingService.cancelScheduling(schedulingId: scheduling.id);
    if (either.isLeft) {
      schedulingErrorMessage = either.left!.message;
    } else {
      hasChange = true;
      await refreshScheduling();
    }

    _setSchedulingLoading(false);
  }

  Future<void> schedulingInService() async {
    _setSchedulingLoading(true);

    final either = await schedulingService.schedulingInService(schedulingId: scheduling.id);
    if (either.isLeft) {
      schedulingErrorMessage = either.left!.message;
    } else {
      hasChange = true;
      await refreshScheduling();
    }

    _setSchedulingLoading(false);
  }

  Future<void> performScheduling() async {
    _setSchedulingLoading(true);

    final either = await schedulingService.performScheduling(schedulingId: scheduling.id);
    if (either.isLeft) {
      schedulingErrorMessage = either.left!.message;
    } else {
      hasChange = true;
      await refreshScheduling();
    }

    _setSchedulingLoading(false);
  }

  Future<void> reviewScheduling({
    required int review,
    required String reviewDetails,
  }) async {
    _setSchedulingLoading(true);

    final either = await schedulingService.addOrEditReview(
      schedulingId: scheduling.id,
      review: review,
      reviewDetails: reviewDetails,
    );
    if (either.isLeft) {
      schedulingErrorMessage = either.left!.message;
    } else {
      await refreshScheduling();
    }

    _setSchedulingLoading(false);
  }

  Future<void> addImageFromGallery() async {
    final eitherPickImage = await offlineImageService.pickImageFromGallery();
    if (eitherPickImage.isLeft) {
      _setNotificationMessage(eitherPickImage.left!.message);
      return;
    }

    _setImagesLoading(true);

    final imageFile = eitherPickImage.right!;
    final addImageEither = await schedulingService.addImage(schedulingId: scheduling.id, imageFile: imageFile);
    if (addImageEither.isLeft) {
      _setNotificationMessage(addImageEither.left!.message);
      _setImagesLoading(false);
      return;
    }

    final imageUrl = addImageEither.right!;
    scheduling.images.add(imageUrl);
    imageListHelper!.insert(imageUrl);

    _setImagesLoading(false);
  }

  Future<void> removeImage(String imageUrl) async {
    final index = scheduling.images.indexWhere((i) => i == imageUrl);
    imageListHelper!.removeAt(index);
    scheduling.images.remove(imageUrl);

    final removeImageEither = await schedulingService.removeImage(schedulingId: scheduling.id, imageUrl: imageUrl);
    if (removeImageEither.isLeft) {
      _setNotificationMessage(removeImageEither.left!.message);
      notifyListeners();
    }
  }

  Future<void> removeImageFromServiceimagesView(String imageUrl) async {
    final index = scheduling.images.indexWhere((i) => i == imageUrl);
    imageListHelper!.removeAt(index);
    scheduling.images.remove(imageUrl);

    _setNotificationMessage('Imagem removida.');

    final removeImageEither = await schedulingService.removeImage(schedulingId: scheduling.id, imageUrl: imageUrl);
    if (removeImageEither.isLeft) {
      _setNotificationMessage(removeImageEither.left!.message);
    } 

    notifyListeners();
  }

  void _clearErrors() {
    schedulingErrorMessage = null;
    notifyListeners();
  }
}
