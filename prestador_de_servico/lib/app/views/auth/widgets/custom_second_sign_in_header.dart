import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';

class CustomSecondSignInHeader extends StatelessWidget {
  final String title;
  const CustomSecondSignInHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/header_creation.png',
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width,
          ),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const BackNavigation(color: Colors.white),
        ],
      ),
    );
  }
}
