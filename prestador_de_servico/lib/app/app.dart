import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/payment/viewmodels/payment_viewmodel.dart';
import 'package:prestador_de_servico/app/views/scheduling/viewmodels/days_viewmodel.dart';
import 'package:prestador_de_servico/app/views/pending_provider_schedules/viewmodels/pending_provider_schedules_viewmodel.dart';
import 'package:prestador_de_servico/app/views/scheduling/viewmodels/service_scheduling_viewmodel.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_edit_viewmodel.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/show_all_services_viewmodel.dart';
import 'package:prestador_de_servico/app/views/service_day/viewmodels/service_day_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/viewmodels/sync/sync_viewmodel.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/create_user_viewmodel.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/sign_in_viewmodel.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/password_reset_viewmodel.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_viewmodel.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_category_edit_viewmodel.dart';
import 'package:prestador_de_servico/app/views/navigation/viewmodels/navigation_viewmodel.dart';
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
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/network/network_service.dart';
import 'package:prestador_de_servico/app/services/payments/payment_service.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/services/service/services_by_category_service.dart';
import 'package:prestador_de_servico/app/services/service_day/service_day_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_payment_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_day_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_service.dart';
import 'package:prestador_de_servico/app/shared/themes/theme.dart';
import 'package:prestador_de_servico/app/views/routes.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SyncController>(
          create: (context) => SyncController(
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
        ChangeNotifierProvider<SignInViewModel>(
          create: (context) => SignInViewModel(
            authService: AuthService(
              authRepository: AuthRepository.create(),
              userRepository: UserRepository.create(),
            ),
          ),
        ),
        ChangeNotifierProvider<CreateUserViewModel>(
          create: (context) => CreateUserViewModel(
            authService: AuthService(
              authRepository: AuthRepository.create(),
              userRepository: UserRepository.create(),
            ),
          ),
        ),
        ChangeNotifierProvider<PasswordResetViewModel>(
          create: (context) => PasswordResetViewModel(
            authService: AuthService(
              authRepository: AuthRepository.create(),
              userRepository: UserRepository.create(),
            ),
          ),
        ),
        ChangeNotifierProvider<NavigationViewModel>(create: (context) => NavigationViewModel()),
        ChangeNotifierProvider<ServiceViewModel>(
          create: (context) => ServiceViewModel(
            serviceCategoryService: ServiceCategoryService(
              offlineRepository: ServiceCategoryRepository.createOffline(),
              onlineRepository: ServiceCategoryRepository.createOnline(),
            ),
            serviceService: ServiceService(
              offlineRepository: ServiceRepository.createOffline(),
              onlineRepository: ServiceRepository.createOnline(),
              imageRepository: ImageRepository.create(),
            ),
            servicesByCategoryService: ServicesByCategoryService(
              offlineRepository: ServicesByCategoryRepository.createOffline(),
            ),
          ),
        ),
        ChangeNotifierProvider<ServiceCategoryEditViewModel>(
          create: (context) => ServiceCategoryEditViewModel(
            serviceCategoryService: ServiceCategoryService(
              onlineRepository: ServiceCategoryRepository.createOnline(),
              offlineRepository: ServiceCategoryRepository.createOffline(),
            ),
          ),
        ),
        ChangeNotifierProvider<ServiceEditViewModel>(
          create: (context) => ServiceEditViewModel(
            serviceService: ServiceService(
              offlineRepository: ServiceRepository.createOffline(),
              onlineRepository: ServiceRepository.createOnline(),
              imageRepository: ImageRepository.create(),
            ),
            offlineImageService: OfflineImageService.create(),
          ),
        ),
        ChangeNotifierProvider<ShowAllServicesViewModel>(
          create: (context) => ShowAllServicesViewModel(
            serviceService: ServiceService(
              offlineRepository: ServiceRepository.createOffline(),
              onlineRepository: ServiceRepository.createOnline(),
              imageRepository: ImageRepository.create(),
            ),
          ),
        ),
        ChangeNotifierProvider<PaymentViewModel>(
          create: (context) => PaymentViewModel(
            paymentService: PaymentService(
              offlineRepository: PaymentRepository.createOffline(),
              onlineRepository: PaymentRepository.createOnline(),
            ),
          ),
        ),
        ChangeNotifierProvider<ServiceDayViewModel>(
          create: (context) => ServiceDayViewModel(
            serviceDayService: ServiceDayService(
              offlineRepository: ServiceDayRepository.createOffline(),
              onlineRepository: ServiceDayRepository.createOnline(),
            ),
          ),
        ),
        ChangeNotifierProvider<DaysViewModel>(
          create: (context) => DaysViewModel(
            schedulingService: SchedulingService(
              onlineRepository: SchedulingRepository.createOnline(),
            ),
          ),
        ),
        ChangeNotifierProvider<ServiceSchedulingViewModel>(
          create: (context) => ServiceSchedulingViewModel(
            schedulingService: SchedulingService(
              onlineRepository: SchedulingRepository.createOnline(),
            ),
          ),
        ),
        ChangeNotifierProvider<PendingProviderSchedulesViewModel>(
          create: (context) => PendingProviderSchedulesViewModel(
            schedulingService: SchedulingService(
              onlineRepository: SchedulingRepository.createOnline(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        theme: mainTheme,
        initialRoute: '/signIn',
        onGenerateRoute: getRoute,
      ),
    );
  }
}
