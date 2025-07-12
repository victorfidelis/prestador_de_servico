import 'package:flutter/material.dart';

class BackNavigation extends StatefulWidget {
  final Function()? overridePop;

  const BackNavigation({
    super.key,
    this.overridePop,
  });

  @override
  State<BackNavigation> createState() => _BackNavigationState();
}

class _BackNavigationState extends State<BackNavigation> {
  late final Function() onPop;

  @override
  void initState() {
    if (widget.overridePop != null) {
      onPop = widget.overridePop!;
    } else {
      onPop = () => Navigator.pop(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPop,
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.arrow_back_ios,
        ),
      ),
    );
  }
}
