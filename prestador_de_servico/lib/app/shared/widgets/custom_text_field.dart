import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isPassword;
  final bool isEmail;
  final bool isNumeric;
  final String? errorMessage;
  final List<TextInputFormatter> inputFormatters;

  CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.isPassword = false,
    this.isEmail = false,
    this.isNumeric = false,
    this.errorMessage,
    this.inputFormatters = const [],
  });

  final ValueNotifier<bool> obscureText = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final TextInputType textInputType;
    if (isNumeric) {
      textInputType = TextInputType.number;
    } else if (isEmail) {
      textInputType = TextInputType.emailAddress;
    } else {
      textInputType = TextInputType.text;
    }

    return GestureDetector(
      onTap: () {
        focusNode.requestFocus();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
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
                      size: 22,
                    ),
                  );
                } else if (isPassword) {
                  suffixIcon = GestureDetector(
                    onTap: _onChangeObscureText,
                    child: const Icon(
                      Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 22,
                    ),
                  );
                }

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 6),
                          errorText: errorMessage,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        obscureText: isPassword && obscureText.value,
                        keyboardType: textInputType,
                        inputFormatters: inputFormatters,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: suffixIcon,
                    ),
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
