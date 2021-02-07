import 'package:flutter/material.dart';

class InputFormField extends StatelessWidget {
  final String labelText;
  final Function validatorFn;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextEditingController controller;
  final Function onTapFn;
  final bool readOnly;

  InputFormField({
    @required this.labelText,
    this.validatorFn,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    @required this.controller,
    this.onTapFn,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: TextInputType.text,
      validator: validatorFn,
      controller: controller,
      onTap: onTapFn,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black, width: 2)),
      ),
    );
  }
}
