import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/login/login_controller.dart';
import 'package:prestador_de_servico/app/views/login/login_view.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(create: (context) => LoginProvider()),
      ],
      child: MaterialApp(
        home: LoginView(),
      ),
    );
  }
}
