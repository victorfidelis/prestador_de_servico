import 'package:prestador_de_servico/app/repositories/auth/auth_repository.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/repositories/payment/payment_repository.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/scheduling_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/services_by_category/services_by_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/service_day/service_day_repository.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/services/client/client_service.dart';
import 'package:prestador_de_servico/app/services/network/network_service.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/payments/payment_service.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/services/service/services_by_category_service.dart';
import 'package:prestador_de_servico/app/services/service_day/service_day_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_payment_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_day_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_service.dart';
import 'package:prestador_de_servico/app/shared/viewmodels/sync/sync_viewmodel.dart';
import 'package:prestador_de_servico/app/views/navigation/viewmodels/navigation_viewmodel.dart';
import 'package:prestador_de_servico/app/views/wrapper/viewmodel/wrapper_viewmodel.dart';
import 'package:provider/provider.dart';

final providers = [
  ChangeNotifierProvider<WrapperViewModel>(create: (context) => WrapperViewModel()),
  ChangeNotifierProvider<SyncViewModel>(
    create: (context) => SyncViewModel(
      networkService: NetworkService.create(),
      syncServiceCategoryService: SyncServiceCategoryService(
        syncRepository: SyncRepository.create(),
        offlineRepository: ServiceCategoryRepository.createOffline(),
        onlineRepository: ServiceCategoryRepository.createOnline(),
      ),
      syncServiceService: SyncServiceService(
        syncRepository: SyncRepository.create(),
        offlineRepository: ServiceRepository.createOffline(),
        onlineRepository: ServiceRepository.createOnline(),
      ),
      syncPaymentService: SyncPaymentService(
        syncRepository: SyncRepository.create(),
        offlineRepository: PaymentRepository.createOffline(),
        onlineRepository: PaymentRepository.createOnline(),
      ),
      syncServiceDayService: SyncServiceDayService(
        syncRepository: SyncRepository.create(),
        offlineRepository: ServiceDayRepository.createOffline(),
        onlineRepository: ServiceDayRepository.createOnline(),
      ),
    ),
  ),
  Provider<AuthService>(
    create: (context) => AuthService(
      authRepository: AuthRepository.create(),
      userRepository: UserRepository.create(),
    ),
  ),
  ChangeNotifierProvider<NavigationViewModel>(create: (context) => NavigationViewModel()),
  Provider<ServiceCategoryService>(
    create: (context) => ServiceCategoryService(
      offlineRepository: ServiceCategoryRepository.createOffline(),
      onlineRepository: ServiceCategoryRepository.createOnline(),
    ),
  ),
  Provider<ServiceService>(
    create: (context) => ServiceService(
      offlineRepository: ServiceRepository.createOffline(),
      onlineRepository: ServiceRepository.createOnline(),
      imageRepository: ImageRepository.create(),
    ),
  ),
  Provider<ServicesByCategoryService>(
    create: (context) => ServicesByCategoryService(
      offlineRepository: ServicesByCategoryRepository.createOffline(),
    ),
  ),
  Provider<OfflineImageService>(create: (context) => OfflineImageService.create()),
  Provider<PaymentService>(
    create: (context) => PaymentService(
      offlineRepository: PaymentRepository.createOffline(),
      onlineRepository: PaymentRepository.createOnline(),
    ),
  ),
  Provider<ServiceDayService>(
    create: (context) => ServiceDayService(
      offlineRepository: ServiceDayRepository.createOffline(),
      onlineRepository: ServiceDayRepository.createOnline(),
    ),
  ),
  Provider<SchedulingService>(
    create: (context) => SchedulingService(
      onlineRepository: SchedulingRepository.createOnline(),
      imageRepository: ImageRepository.create(),
    ),
  ),
  Provider<ClientService>(
    create: (context) => ClientService(
      userRepository: UserRepository.create(),
    ),
  ),
];
