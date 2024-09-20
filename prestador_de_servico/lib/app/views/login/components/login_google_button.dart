import 'package:flutter/material.dart';

class LoginGoogleButton extends StatelessWidget {
  final Function() onTap;

  const LoginGoogleButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
            color: Color(0xffE4E4E4),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/google_logo.png',
                width: 40,
              ),
            ),
            const Text(
              'Google',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
