import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool initialValue;
  final Function() onChanged;
  const CustomSwitch({
    super.key,
    required this.initialValue,
    required this.onChanged
  });

  @override
  State<CustomSwitch> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<CustomSwitch> {
  bool currentValue = true;

  @override
  void initState() {
    currentValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: currentValue,
      activeColor: Theme.of(context).colorScheme.secondary,
      onChanged: (bool value) {
        widget.onChanged();
        setState(() {
          currentValue = value;
        });
      },
    );
  }
}
