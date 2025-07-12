import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/viewmodels/sync/sync_viewmodel.dart';
import 'package:prestador_de_servico/app/views/auth/login_view.dart';
import 'package:prestador_de_servico/app/views/navigation/navigation_view.dart';
import 'package:prestador_de_servico/app/views/wrapper/viewmodel/wrapper_viewmodel.dart';
import 'package:provider/provider.dart';

class WrapperView extends StatefulWidget {
  const WrapperView({super.key});

  @override
  State<WrapperView> createState() => _WrapperViewState();
}

class _WrapperViewState extends State<WrapperView> {

  @override
  void initState() {
    context.read<SyncViewModel>().syncData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WrapperViewModel>(
      builder: (context, state, _) {
        if (state.loggedInUser) {
          return const NavigationView();
        } else {
          return const LoginView();
        }
      },
    );
  }
}
