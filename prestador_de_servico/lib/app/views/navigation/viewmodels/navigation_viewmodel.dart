import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/navigation/viewmodels/navigation_page.dart';

class NavigationViewModel extends ChangeNotifier {
  final PageController pageController = PageController(initialPage: NavigationPage.home);
  int currentPage = NavigationPage.home;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void changePage(int page) {
    currentPage = page;
    pageController.jumpToPage(currentPage);
    notifyListeners();
  }
}
