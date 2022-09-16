import 'package:flutter/material.dart';

void showSnackBar(String message, Color color, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      duration: const Duration(seconds: 3),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
