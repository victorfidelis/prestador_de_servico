import 'package:flutter/material.dart';

class AddServiceButtom extends StatefulWidget {
  final Function() onTap;
  const AddServiceButtom({super.key, required this.onTap});

  @override
  State<AddServiceButtom> createState() => _AddServiceButtomState();
}

class _AddServiceButtomState extends State<AddServiceButtom> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xff00891E),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              offset: const Offset(0, 4),
              blurStyle: BlurStyle.normal,
              blurRadius: 4,
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Novo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 6),
            Icon(
              Icons.add,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
