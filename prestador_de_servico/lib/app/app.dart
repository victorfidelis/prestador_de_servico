import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/app/app_controller.dart';
import 'package:prestador_de_servico/app/controllers/create_user/create_user_controller.dart';
import 'package:prestador_de_servico/app/controllers/login/login_controller.dart';
import 'package:prestador_de_servico/app/controllers/password_reset/password_reset_controller.dart';
import 'package:prestador_de_servico/app/controllers/start/start_controller.dart';
import 'package:prestador_de_servico/app/services/app/app_service.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/themes/theme.dart';
import 'package:prestador_de_servico/app/views/create_user/create_user_view.dart';
import 'package:prestador_de_servico/app/views/service/service_view.dart';
import 'package:prestador_de_servico/app/views/start/start_view.dart';
import 'package:prestador_de_servico/app/views/login/login_view.dart';
import 'package:prestador_de_servico/app/views/password_reset/password_reset_view.dart';
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
      ],
      child: MaterialApp(
        theme: mainTheme,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginView(),
          '/createAccount': (context) => const CreateUserView(),
          '/passwordReset': (context) => const PasswordResetView(),
          '/start': (context) => StartView(),
          '/service': (context) => const ServiceView(),
        },
      ),
    );
  }
}
