import 'package:deepfakedetectorfront/app/review/review_controller.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  final ReviewController controller;

  const ReviewPage({super.key, this.controller = const ReviewController()});

  @override
  Widget build(BuildContext context) {
    const double certainty = 0.91;

    return SafeArea(
      child: Container(
        color: Colors.black87,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withAlpha(18)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Confidence Score',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.auto_graph,
                          color: Colors.cyan.withAlpha(220),
                          size: 28,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 180,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 180,
                              height: 180,
                              child: CircularProgressIndicator(
                                value: certainty,
                                strokeWidth: 9,
                                backgroundColor: Colors.white.withAlpha(18),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.cyan.withAlpha(220),
                                ),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  '91%',
                                  style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 44,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'CERTAINTY',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Highly probable AI-generated artifacts detected in temporal consistency and facial geometry layers.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: const [
                        _InfoChip(label: 'Temporal mismatch', icon: Icons.timelapse),
                        _InfoChip(
                          label: 'Face geometry drift',
                          icon: Icons.face_retouching_natural,
                        ),
                        _InfoChip(label: 'Artifact detection', icon: Icons.blur_on),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.cyan.withAlpha(16),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.cyan.withAlpha(85)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withAlpha(18),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.cyan.withAlpha(26),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.movie_creation_outlined,
                            color: Colors.cyan,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Preview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan.withAlpha(36),
                            Colors.white.withAlpha(6),
                            Colors.cyan.withAlpha(16),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.cyan.withAlpha(70)),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_circle_outline,
                              color: Colors.cyan,
                              size: 70,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Image / Video preview',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'The selected media preview appears here before or after analysis.',
                      style: TextStyle(color: Colors.white70, height: 1.35),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => controller.showScoreExplanationDialog(context),
                      icon: const Icon(Icons.info_outline),
                      label: const Text(
                        'Why this score?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.cyan.withAlpha(16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.cyan.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.cyan),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}