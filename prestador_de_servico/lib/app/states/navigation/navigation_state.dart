abstract class NavigationState {
  int numberPage = 0;
}

class HomeNavigationPage extends NavigationState {
  HomeNavigationPage() {
    numberPage = 0;
  }
}

class AgendaNavigationPage extends NavigationState {
  AgendaNavigationPage() {
    numberPage = 1;
  }
}

class MenuNavigationPage extends NavigationState {
  MenuNavigationPage() {
    numberPage = 2;
  }
}