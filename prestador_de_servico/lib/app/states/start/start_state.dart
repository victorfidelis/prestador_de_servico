abstract class StartState {
  int numberPage = 0;
}

class HomeStart extends StartState {
  HomeStart() {
    numberPage = 0;
  }
}

class AgendaStart extends StartState {
  AgendaStart() {
    numberPage = 1;
  }
}

class MenuStart extends StartState {
  MenuStart() {
    numberPage = 2;
  }
}