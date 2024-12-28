import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
        required this.hint,
        required this.label,
        this.controller,
        this.isPassword = false});
  final String hint;
  final String label;
  final bool isPassword;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: context.theme.colorScheme.outline,
          ),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          label: Text(label, style: TextStyle(
            color: Colors.black
          ),),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey, width: 1))),
    );
  }
}