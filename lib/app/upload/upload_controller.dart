import 'package:flutter/material.dart';

class UploadController {
  const UploadController();

  void showFilePickerSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File picker opened')),
    );
  }
}