import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/start/start_controller.dart';
import 'package:prestador_de_servico/app/states/start/start_state.dart';
import 'package:prestador_de_servico/app/views/agenda/agenda_view.dart';
import 'package:prestador_de_servico/app/views/home/home_view.dart';
import 'package:prestador_de_servico/app/views/menu/menu_view.dart';
import 'package:prestador_de_servico/app/views/start/widgets/custom_menu_buttom.dart';
import 'package:provider/provider.dart';

class StartView extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);
  
  StartView({super.key});


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
          Consumer<StartController>(builder: (context, startController, _) {
          
        return BottomAppBar(
          color: Theme.of(context).colorScheme.secondary,
          shape: const CircularNotchedRectangle(),
          child: Row(
            children: [
              Expanded(
                child: CustomMenuButtom(
                  onTap: () {
                    _pageController.jumpToPage(HomeStart().numberPage);
                    startController.changePage(startState: HomeStart());
                  },
                  icon: Icons.home,
                  text: 'Home',
                  isCurrent: (startController.state is HomeStart),
                ),
              ),
              Expanded(
                child: CustomMenuButtom(
                  onTap: () {
                    _pageController.jumpToPage(AgendaStart().numberPage);
                    startController.changePage(startState: AgendaStart());
                  },
                  icon: Icons.view_agenda_outlined,
                  text: 'Agenda',
                  isCurrent: (startController.state is AgendaStart),
                ),
              ),
              Expanded(
                child: CustomMenuButtom(
                  onTap: () {
                    _pageController.jumpToPage(MenuStart().numberPage);
                    startController.changePage(startState: MenuStart());
                  },
                  icon: Icons.menu,
                  text: 'Menu',
                  isCurrent: (startController.state is MenuStart),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
