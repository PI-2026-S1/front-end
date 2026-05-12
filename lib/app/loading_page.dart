import 'package:deepfakedetectorfront/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool _isAnimating = true;
  bool _forward = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    setState(() {
      _isLoggedIn = userId != null && userId.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: _forward ? 1.0 : 1.1, end: _forward ? 1.1 : 1.0),
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          builder: (context, scale, _) {
            return Transform.scale(
              scale: scale,
              child: Hero(
                tag: 'logo',
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withAlpha(
                          (255 * 0.6).toInt(),
                        ),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                // child: Image.asset(
                //   'lib/app/assets/horizontalColored.png',
                //   width: MediaQuery.of(context).size.width * 0.8,
                // ),
              ),
            );
          },
          onEnd: () {
            if (mounted && _isAnimating) {
              setState(() {
                _forward = !_forward;
              });
            } else if (!_isAnimating) {
              if (_isLoggedIn) {
                Navigator.of(context).pushReplacementNamed('/home');
              } else {
                Navigator.of(context).pushReplacementNamed('/first');
              }
            }
          },
        ),
      ),
    );
  }
}
