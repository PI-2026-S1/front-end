import 'package:deepfakedetectorfront/app/home/home_page.dart';
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

  @override
  Widget build(BuildContext context) {
    const pages = [HomePage(), UploadPage(), ReviewPage()];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
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
