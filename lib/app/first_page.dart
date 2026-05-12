import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), centerTitle: true),
      body: SafeArea(
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
                'This is a generic home screen. Use the buttons below to navigate or perform actions.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // placeholder action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Primary action tapped')),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Primary Action'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  // placeholder action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Secondary action tapped')),
                  );
                },
                icon: const Icon(Icons.settings),
                label: const Text('Settings'),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () {
                    // simple footer action
                  },
                  child: const Text('About'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
