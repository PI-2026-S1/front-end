import 'dart:math' as math;
import 'package:deepfakedetectorfront/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SafeScoreCard extends StatelessWidget {
  final double score; // 0.0 até 1.0

  const SafeScoreCard({super.key, this.score = 0.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          _SafeScoreRing(score: score),
          const SizedBox(height: 20),
          const Text(
            'INTEGRIDADE TOTAL',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Nenhuma anomalia crítica detectada\nnas últimas 24h.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.neutral,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SafeScoreRing extends StatelessWidget {
  final double score;

  const _SafeScoreRing({required this.score});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth * 0.55, 160.0);
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RingPainter(progress: score),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${(score * 100).toInt()}%',
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'SAFE_SCORE',
                    style: TextStyle(
                      color: AppColors.neutral,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;
    const strokeWidth = 10.0;
    const startAngle = -math.pi / 2;

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF1B2A44)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = const Color(0xFF00F2FE).withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * math.pi * progress,
      false,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF00F2FE), Color(0xFF0077FF)],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}