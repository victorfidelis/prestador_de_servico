import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';

class EditScheduledServicesViewmodel extends ChangeNotifier {
  final SchedulingService schedulingService;
  Scheduling scheduling;
  late List<ScheduledService> scheduledServicesOriginal;

  bool editLoading = false;

  final TextEditingController rateController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  ValueNotifier<bool> editSuccessful = ValueNotifier(false);
  ValueNotifier<String?> notificationMessage = ValueNotifier(null);

  String? discountError;

  EditScheduledServicesViewmodel({
    required this.schedulingService,
    required this.scheduling,
  }) {
    scheduledServicesOriginal = List.from(scheduling.services);
    _loadFields();
  }

  @override
  void dispose() {
    rateController.dispose();
    discountController.dispose();
    super.dispose();
  }

  int get quantityOfActiveServices => scheduling.services.where((s) => !s.removed).length;

  void _setEditLoading(bool value) {
    editLoading = value;
    notifyListeners();
  }

  void _setNotificationMessage(String value) {
    notificationMessage.value = null; // Necessário para garantir que o ValueNotifier notifique os ouvintes
    notificationMessage.value = value;
  }

  void _loadFields() {
    if (scheduling.totalRate > 0) {
      rateController.text = scheduling.totalRate.toString();
    }
    if (scheduling.totalDiscount > 0) {
      discountController.text = scheduling.totalDiscount.toString();
    }
  }

  void removeService({required int index}) {
    final service = scheduling.services[index];

    if (scheduledServicesOriginal.contains(service)) {
      scheduling.services[index] = service.copyWith(removed: true);
    } else {
      scheduling.services.remove(service);
    }

    scheduling = scheduling.copyWith(
      totalPrice: scheduling.totalPrice - service.price,
    );

    notifyListeners();
  }

  void returnService({required int index}) {
    final service = scheduling.services[index];

    scheduling.services[index] = service.copyWith(removed: false);
    scheduling = scheduling.copyWith(
      totalPrice: scheduling.totalPrice + service.price,
    );

    notifyListeners();
  }

  void changeRate() {
    double rate = 0;
    if (rateController.text.isNotEmpty) {
      rate = double.parse(rateController.text.replaceAll(',', '.'));
    }
    scheduling = scheduling.copyWith(totalRate: rate);
    notifyListeners();
  }

  void changeDicount() {
    double discount = 0;
    if (discountController.text.isNotEmpty) {
      discount = double.parse(discountController.text.replaceAll(',', '.'));
    }
    scheduling = scheduling.copyWith(totalDiscount: discount);
    notifyListeners();
  }

  void addService({required Service service}) {
    ScheduledService scheduledService = ScheduledService(
      scheduledServiceId: _getNextScheduledServiceId(),
      id: service.id,
      serviceCategoryId: service.serviceCategoryId,
      name: service.name,
      price: service.price,
      hours: service.hours,
      minutes: service.minutes,
      imageUrl: service.imageUrl,
      isAdditional: true,
      removed: false,
    );

    scheduling.services.add(scheduledService);
    scheduling = scheduling.copyWith(
      totalPrice: scheduling.totalPrice + service.price,
    );

    notifyListeners();
  }

  int _getNextScheduledServiceId() {
    return 1 + scheduling.services.map((s) => s.scheduledServiceId).reduce((id1, id2) => id1 > id2 ? id1 : id2);
  }

  bool validateSave() {
    if (scheduling.totalPriceCalculated < 0) {
      discountError = 'Informe um valor válido';
      notifyListeners();
      return false;
    }

    return true;
  }

  Future<void> save() async {
    _setEditLoading(true);

    scheduling = scheduling.copyWith(
      endDateAndTime: schedulingService.calculateEndDate(
        scheduling.services,
        scheduling.startDateAndTime,
      ),
    );

    final editEither = await schedulingService.editServicesAndPricesOfScheduling(
      schedulingId: scheduling.id,
      totalRate: scheduling.totalRate,
      totalDiscount: scheduling.totalDiscount,
      totalPrice: scheduling.totalPrice,
      scheduledServices: scheduling.services,
      newEndDate: scheduling.endDateAndTime,
    );

    if (editEither.isLeft) {
      _setNotificationMessage(editEither.left!.message);
    } else {
      _setNotificationMessage('Serviços e preços alterados com sucesso!');
      editSuccessful.value = true;
    }

    _setEditLoading(false);
  }
}
