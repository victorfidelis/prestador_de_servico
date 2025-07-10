import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/viewmodels/sync/sync_viewmodel.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/sign_in_viewmodel.dart';
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
import 'package:prestador_de_servico/app/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
        ChangeNotifierProvider<SignInViewModel>(
          create: (context) => SignInViewModel(
            authService: AuthService(
              authRepository: AuthRepository.create(),
              userRepository: UserRepository.create(),
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
      ],
      child: MaterialApp(
        theme: mainTheme,
        initialRoute: '/signIn',
        onGenerateRoute: getRoute,
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
      ),
    );
  }
}
