import 'package:flutter/material.dart';

class HomeController {
  const HomeController();

  void showPrimaryActionSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Primary action tapped')),
    );
  }

  void showSettingsSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Secondary action tapped')),
    );
  }
}