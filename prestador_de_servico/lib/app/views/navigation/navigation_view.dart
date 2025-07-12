import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/navigation/viewmodels/navigation_page.dart';
import 'package:prestador_de_servico/app/views/navigation/viewmodels/navigation_viewmodel.dart';
import 'package:prestador_de_servico/app/views/agenda/agenda_view.dart';
import 'package:prestador_de_servico/app/views/home/home_view.dart';
import 'package:prestador_de_servico/app/views/menu/menu_view.dart';
import 'package:prestador_de_servico/app/views/navigation/widgets/custom_menu_buttom.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  final NavigationViewModel navigationViewModel = NavigationViewModel();

  @override
  void dispose() {
    navigationViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: navigationViewModel.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeView(),
          AgendaView(),
          MenuView(),
        ],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: navigationViewModel,
        builder: (context, _) {
          return BottomAppBar(
            color: Theme.of(context).colorScheme.secondary,
            shape: const CircularNotchedRectangle(),
            child: Row(
              children: [
                Expanded(
                  child: CustomMenuButtom(
                    onTap: () => navigationViewModel.changePage(NavigationPage.home),
                    icon: Icons.home,
                    text: 'Home',
                    isCurrent: navigationViewModel.currentPage == NavigationPage.home,
                  ),
                ),
                Expanded(
                  child: CustomMenuButtom(
                    onTap: () => navigationViewModel.changePage(NavigationPage.agenda),
                    icon: Icons.view_agenda_outlined,
                    text: 'Agenda',
                    isCurrent: navigationViewModel.currentPage == NavigationPage.agenda,
                  ),
                ),
                Expanded(
                  child: CustomMenuButtom(
                    onTap: () => navigationViewModel.changePage(NavigationPage.menu),
                    icon: Icons.menu,
                    text: 'Menu',
                    isCurrent: navigationViewModel.currentPage == NavigationPage.menu,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
