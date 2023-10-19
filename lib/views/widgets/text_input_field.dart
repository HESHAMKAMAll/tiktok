import 'package:flutter/material.dart';
import '../../constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final IconData prefixIcon;
  final TextInputType keyboardType;

  const TextInputField({super.key,
    required this.controller,
    required this.hintText,
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
        // isCollapsed: true,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        hintStyle: const TextStyle(fontSize: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: borderColor)),
        // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: borderColor)),
        // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: borderColor)),
      ),
      obscureText: isObscure,
    );
  }
}
