import 'package:flutter/material.dart';

class ServiceImagesView extends StatefulWidget {
  const ServiceImagesView({super.key});

  @override
  State<ServiceImagesView> createState() => _ServiceImagesViewState();
}

class _ServiceImagesViewState extends State<ServiceImagesView> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 26, vertical: 32),
      child: Column(
        children: [
          SizedBox(height: 50),
          Text(
            'Adicione imagens',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 50),
          Row(
            
          ),
        ],
      ),
    );
  }
}