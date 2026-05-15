import 'package:flutter/material.dart';

class ReviewController {
  const ReviewController();

  void showReviewContentLoadedSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review content loaded')),
    );
  }

  Future<void> showScoreExplanationDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Why this score?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The model assigned this certainty because it detected patterns commonly associated with manipulated media:',
                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
              SizedBox(height: 16),
              _ReasonLine(text: 'Temporal inconsistency between frames'),
              _ReasonLine(text: 'Lighting and shadow mismatch'),
              _ReasonLine(text: 'Facial geometry and texture artifacts'),
              _ReasonLine(text: 'Minor blending irregularities around edges'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.cyan)),
            ),
          ],
        );
      },
    );
  }
}

class _ReasonLine extends StatelessWidget {
  final String text;

  const _ReasonLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(Icons.circle, size: 8, color: Colors.cyan),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
