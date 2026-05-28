import 'package:deepfakedetectorfront/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _oldIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ), // Slightly faster feels more responsive
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve:
          Curves.easeOutCubic, // Smoother sliding curve for a background pill
    );
    _oldIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(covariant NavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _oldIndex = oldWidget.currentIndex;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.dashboard, 'label': 'INÍCIO'},
      {'icon': Icons.upload, 'label': 'ENVIAR'},
      {'icon': Icons.preview, 'label': 'ANÁLISE'},
    ];

    // Calculate the horizontal position multiplier (-1.0 to 1.0 for Align)
    double getAlignmentX(int index) {
      // Math to convert index to a -1 to 1 scale based on item count
      final double step = 2 / (items.length - 1);
      return -1.0 + (step * index);
    }

    return Container(
      decoration: const BoxDecoration(color: AppColors.background),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. BACKGROUND SLIDING ANIMATION
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final double startX = getAlignmentX(_oldIndex);
                final double endX = getAlignmentX(widget.currentIndex);
                final double currentX =
                    startX + (endX - startX) * _animation.value;

                return Align(
                  alignment: Alignment(currentX, 0),
                  // FractionallySizedBox ensures the highlight perfectly matches the column width
                  child: FractionallySizedBox(
                    widthFactor: 1 / items.length,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(16), // Pill shape
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. FOREGROUND ICONS AND TEXT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              items.length,
              (index) => Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior
                      .opaque, // Ensures the whole area is clickable
                  onTap: () => widget.onItemTapped(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            // Optional: Keep the subtle glow on the icon itself
                            boxShadow: widget.currentIndex == index
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(
                                        0.30,
                                      ),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Icon(
                            items[index]['icon'] as IconData,
                            color: widget.currentIndex == index
                                ? AppColors.primary
                                : AppColors.neutral,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (items[index]['label'] as String).toUpperCase(),
                          style: TextStyle(
                            color: widget.currentIndex == index
                                ? AppColors.primary
                                : AppColors.neutral,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
