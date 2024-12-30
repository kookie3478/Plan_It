import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldComponent extends StatelessWidget {
  const TextFieldComponent({
    super.key,
    required this.hint,
    required this.controller,
    required this.height,
    this.keyboardType = TextInputType.text,
    this.mx= 1, this.width=100,
  });

  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int mx;
  final double height;
  final double width;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      //color:Colors.green,
      child: TextField(
        controller: controller,
        maxLines: mx,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white38,
          counterText: "",
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: context.theme.colorScheme.outline,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.colorScheme.outline),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.colorScheme.outline),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }
}
