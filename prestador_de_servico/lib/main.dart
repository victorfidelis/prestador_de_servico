import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
