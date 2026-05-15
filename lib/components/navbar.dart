import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const NavBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.dashboard, 'label': 'Home'},
      {'icon': Icons.preview, 'label': 'Review'},
      {'icon': Icons.upload, 'label': 'Upload'},
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.blue.shade800, width: 2),
          bottom: BorderSide(color: Colors.purple.shade800, width: 2),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border(
            left: BorderSide(color: Colors.blue.shade900, width: 3),
            right: BorderSide(color: Colors.purple.shade900, width: 3),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            items.length,
            (index) => GestureDetector(
              onTap: () => onItemTapped(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: currentIndex == index
                          ? [
                              BoxShadow(
                                color: Colors.cyan.withOpacity(0.6),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      items[index]['icon'] as IconData,
                      color: currentIndex == index ? Colors.cyan : Colors.grey,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (items[index]['label'] as String).toUpperCase(),
                    style: TextStyle(
                      color: currentIndex == index ? Colors.cyan : Colors.grey,
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
    );
  }
}
