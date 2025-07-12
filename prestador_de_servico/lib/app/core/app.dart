import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/core/providers.dart';
import 'package:prestador_de_servico/app/shared/themes/theme.dart';
import 'package:prestador_de_servico/app/core/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
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
