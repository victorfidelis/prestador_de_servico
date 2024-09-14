import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final bool isEmail;

  CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.isEmail = false,
  });

  final FocusNode _node = FocusNode();
  ValueNotifier<bool> obscureText = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _node.requestFocus();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Color(0x80000000),
                offset: Offset(0, 4),
                blurStyle: BlurStyle.normal,
                blurRadius: 4,
              )
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            ListenableBuilder(
              listenable: obscureText,
              builder: (context, _) {
                Widget suffixIcon = Container();
                if (isPassword && obscureText.value) {
                  suffixIcon = GestureDetector(
                    onTap: _onChangeObscureText,
                    child: const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.grey,
                      size: 28,
                    ),
                  );
                } else if (isPassword) {
                  suffixIcon = GestureDetector(
                    onTap: _onChangeObscureText,
                    child: const Icon(
                      Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 28,
                    ),
                  );
                }

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _node,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        obscureText: isPassword && obscureText.value,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    suffixIcon,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onChangeObscureText() {
    obscureText.value = !obscureText.value;
  }
}
