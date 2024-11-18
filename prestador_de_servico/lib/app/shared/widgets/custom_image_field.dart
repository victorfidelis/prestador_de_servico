import 'dart:io';

import 'package:flutter/material.dart';

class CustomImageField extends StatelessWidget {
  final Function() onTap;
  final String label;
  final File? imageFile;
  final String? imageUrl;

  const CustomImageField({
    super.key,
    required this.onTap,
    required this.label,
    this.imageFile,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    Image image;
    
    if (imageFile != null) {
      image = Image.file(imageFile!, fit: BoxFit.fitWidth);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      image = Image.network(imageUrl!, fit: BoxFit.fitWidth);
    } else {
      image = Image.asset('assets/images/adicionar_imagem.jpg');
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              offset: const Offset(0, 4),
              blurStyle: BlurStyle.normal,
              blurRadius: 4,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 6),
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: image,
            )
          ],
        ),
      ),
    );
  }
}
