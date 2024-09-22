import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/app/app_controller.dart';
import 'package:prestador_de_servico/app/controllers/create_user/create_user_controller.dart';
import 'package:prestador_de_servico/app/controllers/login/login_controller.dart';
import 'package:prestador_de_servico/app/services/app/app_service.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/views/create_user/create_account_view.dart';
import 'package:prestador_de_servico/app/views/login/login_view.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppController>(
          create: (context) => AppController(appService: AppService.create())),
        ChangeNotifierProvider<LoginController>(
          create: (context) => LoginController(authService: AuthService.create())),
        ChangeNotifierProvider<CreateUserController>(
          create: (context) => CreateUserController(authService: AuthService.create())),
      ],
      child: MaterialApp(
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginView(),
          '/createAccount': (context) => const CreateUserView(),
        },
      ),
    );
  }
}
