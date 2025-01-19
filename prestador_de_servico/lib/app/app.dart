import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/service/service_edit_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/show_all_services_controller.dart';
import 'package:prestador_de_servico/app/controllers/sync/sync_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/create_user_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/sign_in_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/password_reset_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_edit_controller.dart';
import 'package:prestador_de_servico/app/controllers/navigation/navigation_controller.dart';
import 'package:prestador_de_servico/app/repositories/auth/auth_repository.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/services_by_category/services_by_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/network/network_service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/services/service/services_by_category_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_service.dart';
import 'package:prestador_de_servico/app/shared/themes/theme.dart';
import 'package:prestador_de_servico/app/views/auth/create_user_view.dart';
import 'package:prestador_de_servico/app/views/service/service_category_edit_view.dart';
import 'package:prestador_de_servico/app/views/service/service_view.dart';
import 'package:prestador_de_servico/app/views/navigation/navigation_view.dart';
import 'package:prestador_de_servico/app/views/auth/sign_in_view.dart';
import 'package:prestador_de_servico/app/views/auth/password_reset_view.dart';
import 'package:prestador_de_servico/app/views/service/service_edit_view.dart';
import 'package:prestador_de_servico/app/views/service/show_all_services_view.dart';
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
          ),
        ),
        ChangeNotifierProvider<SignInController>(
          create: (context) => SignInController(
            authService: AuthService(
              authRepository: AuthRepository.create(),
              userRepository: UserRepository.create(),
            ),
          ),
        ),
        ChangeNotifierProvider<CreateUserController>(
          create: (context) => CreateUserController(
            authService: AuthService(
              authRepository: AuthRepository.create(),
              userRepository: UserRepository.create(),
            ),
          ),
        ),
        ChangeNotifierProvider<PasswordResetController>(
          create: (context) => PasswordResetController(
            authService: AuthService(
              authRepository: AuthRepository.create(),
              userRepository: UserRepository.create(),
            ),
          ),
        ),
        ChangeNotifierProvider<NavigationController>(create: (context) => NavigationController()),
        ChangeNotifierProvider<ServiceController>(
          create: (context) => ServiceController(
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
        ChangeNotifierProvider<ServiceCategoryEditController>(
          create: (context) => ServiceCategoryEditController(
            serviceCategoryService: ServiceCategoryService(
              onlineRepository: ServiceCategoryRepository.createOnline(),
              offlineRepository: ServiceCategoryRepository.createOffline(),
            ),
          ),
        ),
        ChangeNotifierProvider<ServiceEditController>(
          create: (context) => ServiceEditController(
            serviceService: ServiceService(
              offlineRepository: ServiceRepository.createOffline(),
              onlineRepository: ServiceRepository.createOnline(),
              imageRepository: ImageRepository.create(),
            ),
            offlineImageService: OfflineImageService.create(),
          ),
        ),
        ChangeNotifierProvider<ShowAllServicesController>(
          create: (context) => ShowAllServicesController(
            serviceService: ServiceService(
              offlineRepository: ServiceRepository.createOffline(),
              onlineRepository: ServiceRepository.createOnline(),
              imageRepository: ImageRepository.create(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        theme: mainTheme,
        initialRoute: '/signIn',
        routes: {
          '/signIn': (context) => const SignInView(),
          '/createAccount': (context) => const CreateUserView(),
          '/passwordReset': (context) => const PasswordResetView(),
          '/navigation': (context) => NavigationView(),
          '/service': (context) => const ServiceView(),
          '/serviceCategoryEdit': (context) => const ServiceCategoryEditView(),
          '/serviceEdit': (context) => const ServiceEditView(),
          '/showAllServices': (context) => const ShowAllServicesView(),
        },
      ),
    );
  }
}
