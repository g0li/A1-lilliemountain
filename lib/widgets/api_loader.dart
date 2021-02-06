import 'package:flutter/material.dart';

class ApiLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Color(0xffF28F3B),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Please wait...',
        ),
      ],
    );
  }
}
