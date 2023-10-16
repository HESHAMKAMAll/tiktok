import 'package:flutter/material.dart';
import '../../constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObscure;
  final IconData prefixIcon;
  final TextInputType keyboardType;

  const TextInputField({
    required this.controller,
    required this.labelText,
    this.isObscure = false,
    required this.prefixIcon,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        isDense: true,
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        labelStyle: TextStyle(fontSize: 20),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: borderColor)),
      ),
      obscureText: isObscure,
    );
  }
}
