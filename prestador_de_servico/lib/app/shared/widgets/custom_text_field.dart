import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isPassword;
  final bool isEmail;
  final bool isNumeric;
  final String? errorMessage;
  final List<TextInputFormatter> inputFormatters;
  final Function(String)? onChanged;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
    this.isPassword = false,
    this.isEmail = false,
    this.isNumeric = false,
    this.errorMessage,
    this.inputFormatters = const [],
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final ValueNotifier<bool> _obscureText = ValueNotifier(true);
  late final FocusNode _focusNode;

  @override
  void initState() {
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextInputType textInputType;
    if (widget.isNumeric) {
      textInputType = TextInputType.number;
    } else if (widget.isEmail) {
      textInputType = TextInputType.emailAddress;
    } else {
      textInputType = TextInputType.text;
    }

    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
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
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            ListenableBuilder(
              listenable: _obscureText,
              builder: (context, _) {
                Widget suffixIcon = Container();
                if (widget.isPassword && _obscureText.value) {
                  suffixIcon = GestureDetector(
                    onTap: _onChangeObscureText,
                    child: const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.grey,
                      size: 22,
                    ),
                  );
                } else if (widget.isPassword) {
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
                        controller: widget.controller,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 6),
                          errorText: widget.errorMessage,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        obscureText: widget.isPassword && _obscureText.value,
                        keyboardType: textInputType,
                        inputFormatters: widget.inputFormatters,
                        onChanged: widget.onChanged,
                        maxLines: widget.maxLines,
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
    _obscureText.value = !_obscureText.value;
  }
}
