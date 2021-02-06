import 'package:flutter/material.dart';

class InputFormField extends StatelessWidget {
  final String labelText;
  final Function validatorFn;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextEditingController controller;

  InputFormField({
    @required this.labelText,
    this.validatorFn,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: TextInputType.text,
      validator: validatorFn,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black, width: 2)),
      ),
    );
  }
}
