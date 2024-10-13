import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/app/app_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/create_user_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/sign_in_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/password_reset_controller.dart';
import 'package:prestador_de_servico/app/controllers/service_category/service_category_controller.dart';
import 'package:prestador_de_servico/app/controllers/service_category/service_category_edit_controller.dart';
import 'package:prestador_de_servico/app/controllers/navigation/navigation_controller.dart';
import 'package:prestador_de_servico/app/repositories/auth/auth_repository.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/services/service_category/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/themes/theme.dart';
import 'package:prestador_de_servico/app/views/auth/create_user_view.dart';
import 'package:prestador_de_servico/app/views/service/service_category_edit_view.dart';
import 'package:prestador_de_servico/app/views/service/service_category_view.dart';
import 'package:prestador_de_servico/app/views/navigation/navigation_view.dart';
import 'package:prestador_de_servico/app/views/auth/sign_in_view.dart';
import 'package:prestador_de_servico/app/views/auth/password_reset_view.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppController>(
            create: (context) => AppController()),
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
        ChangeNotifierProvider<NavigationController>(
            create: (context) => NavigationController()),
        ChangeNotifierProvider<ServiceCategoryController>(
            create: (context) => ServiceCategoryController(
                  serviceCategoryService: ServiceCategoryService.create(),
                )),
        ChangeNotifierProvider<ServiceCategoryEditController>(
            create: (context) => ServiceCategoryEditController(
                  serviceCategoryService: ServiceCategoryService.create(),
                )),
      ],
      child: MaterialApp(
        theme: mainTheme,
        initialRoute: '/signIn',
        routes: {
          '/signIn': (context) => const SignInView(),
          '/createAccount': (context) => const CreateUserView(),
          '/passwordReset': (context) => const PasswordResetView(),
          '/navigation': (context) => NavigationView(),
          '/serviceCategory': (context) => const ServiceCategoryView(),
          '/serviceCategoryEdit': (context) => const ServiceCategoryEditView(),
        },
      ),
    );
  }
}
