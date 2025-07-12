import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/navigation/viewmodels/navigation_viewmodel.dart';
import 'package:prestador_de_servico/app/views/navigation/states/navigation_state.dart';
import 'package:prestador_de_servico/app/views/agenda/agenda_view.dart';
import 'package:prestador_de_servico/app/views/home/home_view.dart';
import 'package:prestador_de_servico/app/views/menu/menu_view.dart';
import 'package:prestador_de_servico/app/views/navigation/widgets/custom_menu_buttom.dart';
import 'package:provider/provider.dart';

class NavigationView extends StatefulWidget {

  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeView(),
          AgendaView(),
          MenuView(),
        ],
      ),
      bottomNavigationBar:
          Consumer<NavigationViewModel>(builder: (context, navigationViewModel, _) {
          
        return BottomAppBar(
          color: Theme.of(context).colorScheme.secondary,
          shape: const CircularNotchedRectangle(),
          child: Row(
            children: [
              Expanded(
                child: CustomMenuButtom(
                  onTap: () {
                    _pageController.jumpToPage(HomeNavigationPage().numberPage);
                    navigationViewModel.changePage(navigationState: HomeNavigationPage());
                  },
                  icon: Icons.home,
                  text: 'Home',
                  isCurrent: (navigationViewModel.state is HomeNavigationPage),
                ),
              ),
              Expanded(
                child: CustomMenuButtom(
                  onTap: () {
                    _pageController.jumpToPage(AgendaNavigationPage().numberPage);
                    navigationViewModel.changePage(navigationState: AgendaNavigationPage());
                  },
                  icon: Icons.view_agenda_outlined,
                  text: 'Agenda',
                  isCurrent: (navigationViewModel.state is AgendaNavigationPage),
                ),
              ),
              Expanded(
                child: CustomMenuButtom(
                  onTap: () {
                    _pageController.jumpToPage(MenuNavigationPage().numberPage);
                    navigationViewModel.changePage(navigationState: MenuNavigationPage());
                  },
                  icon: Icons.menu,
                  text: 'Menu',
                  isCurrent: (navigationViewModel.state is MenuNavigationPage),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
