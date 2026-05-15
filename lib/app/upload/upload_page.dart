import 'package:deepfakedetectorfront/app/upload/upload_controller.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatelessWidget {
  final UploadController controller;

  const UploadPage({super.key, this.controller = const UploadController()});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Upload',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Upload new content for analysis.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.showFilePickerSnack(context),
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Choose File'),
            ),
          ],
        ),
      ),
    );
  }
}