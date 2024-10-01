import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/app/app_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/create_user_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/login_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/password_reset_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_edit_controller.dart';
import 'package:prestador_de_servico/app/controllers/start/start_controller.dart';
import 'package:prestador_de_servico/app/services/app/app_service.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/themes/theme.dart';
import 'package:prestador_de_servico/app/views/auth/create_user_view.dart';
import 'package:prestador_de_servico/app/views/service/service_category_edit_view.dart';
import 'package:prestador_de_servico/app/views/service/service_category_view.dart';
import 'package:prestador_de_servico/app/views/start/start_view.dart';
import 'package:prestador_de_servico/app/views/auth/login_view.dart';
import 'package:prestador_de_servico/app/views/auth/password_reset_view.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppController>(
            create: (context) =>
                AppController(appService: AppService.create())),
        ChangeNotifierProvider<LoginController>(
            create: (context) =>
                LoginController(authService: AuthService.create())),
        ChangeNotifierProvider<CreateUserController>(
            create: (context) =>
                CreateUserController(authService: AuthService.create())),
        ChangeNotifierProvider<PasswordResetController>(
            create: (context) =>
                PasswordResetController(authService: AuthService.create())),
        ChangeNotifierProvider<StartController>(
            create: (context) => StartController()),
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
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginView(),
          '/createAccount': (context) => const CreateUserView(),
          '/passwordReset': (context) => const PasswordResetView(),
          '/start': (context) => StartView(),
          '/serviceCategory': (context) => const ServiceCategoryView(),
          '/serviceCategoryEdit': (context) => ServiceCategoryEditView(),
        },
      ),
    );
  }
}
