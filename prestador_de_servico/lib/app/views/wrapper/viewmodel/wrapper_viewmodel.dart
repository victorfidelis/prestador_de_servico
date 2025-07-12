import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';


class WrapperViewModel extends ChangeNotifier {
  User? user;
  bool get loggedInUser => user != null;

  void logIn(User user) {
    this.user = user;
    notifyListeners();
  }

  void logOut() {
    user = null;
    notifyListeners();
  }
}