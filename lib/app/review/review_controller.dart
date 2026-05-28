import 'package:deepfakedetectorfront/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ReviewController {
  const ReviewController();

  void showReviewContentLoadedSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conteúdo da análise carregado')),
    );
  }

  Future<void> showScoreExplanationDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Por que este resultado?',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'O modelo atribuiu esta certeza porque detectou padrões comumente associados a mídias manipuladas:',
                style: TextStyle(color: AppColors.neutralLight, height: 1.4),
              ),
              SizedBox(height: 16),
              _ReasonLine(text: 'Inconsistência temporal entre quadros'),
              _ReasonLine(text: 'Descompasso de iluminação e sombras'),
              _ReasonLine(text: 'Artefatos de geometria e textura facial'),
              _ReasonLine(
                text: 'Irregularidades sutis de mesclagem nas bordas',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Fechar',
                style: TextStyle(color: AppColors.primary),
              ),
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
            child: Icon(Icons.circle, size: 8, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.neutralLight,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
