import 'package:deepfakedetectorfront/app/home/home_controller.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final HomeController controller;

  const HomePage({super.key, this.controller = const HomeController()});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Welcome',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is a generic home screen. Use the navbar to navigate.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.showPrimaryActionSnack(context),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Primary Action'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => controller.showSettingsSnack(context),
              icon: const Icon(Icons.settings),
              label: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}