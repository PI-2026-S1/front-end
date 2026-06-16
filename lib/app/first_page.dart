import 'package:deepfakedetectorfront/app/home/home_page.dart';
import 'package:deepfakedetectorfront/app/deepfake_controller.dart';
import 'package:deepfakedetectorfront/app/review/review_page.dart';
import 'package:deepfakedetectorfront/app/upload/upload_page.dart';
import 'package:deepfakedetectorfront/components/navbar.dart';
import 'package:deepfakedetectorfront/utils/app_colors.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _currentIndex = 0;
  late final DeepfakeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DeepfakeController();
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        controller: _controller,
        onUploadPressed: () {
          setState(() {
            _currentIndex = 1;
          });
        },
      ),
      UploadPage(controller: _controller),
      ReviewPage(deepfakeController: _controller),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onItemTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
