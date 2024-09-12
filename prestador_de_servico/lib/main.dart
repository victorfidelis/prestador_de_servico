import 'package:flutter/material.dart';

void main() {
  runApp(const MyAppNew());
}

class MyAppNew extends StatelessWidget {
  const MyAppNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prestador de Serviço'),
      ),
      body: const Center(
        child: Text('Em desenvolvimento ...'),
      ),
    );
  }
}
