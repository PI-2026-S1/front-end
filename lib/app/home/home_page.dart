import 'package:deepfakedetectorfront/app/deepfake_controller.dart';
import 'package:deepfakedetectorfront/components/greeting_section.dart';
import 'package:deepfakedetectorfront/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final DeepfakeController controller;
  final VoidCallback onUploadPressed;

  const HomePage({
    super.key,
    required this.controller,
    required this.onUploadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final state = controller.state;
        final result = state.result;

        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: AppColors.background),
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(0.8, -0.9),
                              radius: 0.9,
                              colors: [
                                AppColors.primary.withOpacity(0.14),
                                AppColors.background,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const GreetingSection(),
                          const SizedBox(height: 24),
                          if (state.hasError)
                            _StatusBanner(
                              title: 'Problema ao sincronizar',
                              message: state.errorMessage ?? 'Tente novamente.',
                              icon: Icons.wifi_off,
                              color: Colors.redAccent,
                            ),
                          if (state.hasError) const SizedBox(height: 16),
                          if (result != null)
                            _LatestScanCard.fromResult(result)
                          else
                            const _LatestScanCard(
                              score: 0.0,
                              summary:
                                  'Nenhum resultado disponível ainda. Envie um vídeo para começar uma nova análise.',
                              timestamp: 'Nenhuma análise executada',
                              labels: ['Upload', 'Status', 'Resultado'],
                              emptyState: true,
                            ),
                          if (state.isBusy) ...[
                            const SizedBox(height: 16),
                            _StatusBanner(
                              title: state.isUploading
                                  ? 'Enviando vídeo'
                                  : state.isRestoring
                                  ? 'Restaurando última análise'
                                  : 'Atualizando resultado',
                              message: state.isUploading
                                  ? 'O arquivo está sendo enviado para o backend.'
                                  : state.isRestoring
                                  ? 'Recuperando o último job salvo localmente.'
                                  : 'Consultando o status do job em processamento.',
                              icon: Icons.query_stats,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              right: 16,
              child: _UploadFab(onTap: onUploadPressed),
            ),
          ],
        );
      },
    );
  }
}

class _LatestScanCard extends StatelessWidget {
  final double score;
  final String summary;
  final String timestamp;
  final List<String> labels;
  final bool emptyState;

  const _LatestScanCard({
    required this.score,
    required this.summary,
    required this.timestamp,
    required this.labels,
    this.emptyState = false,
  });

  factory _LatestScanCard.fromResult(dynamic result) {
    final fakeProbability = result.fakeProbability ?? 0.0;
    final labels = <String>[
      if (result.verdict != null && result.verdict!.isNotEmpty) result.verdict!,
      if (result.status.isNotEmpty) result.status,
      ...result.artifacts.take(2),
    ];

    return _LatestScanCard(
      score: fakeProbability,
      summary: result.verdict?.isNotEmpty == true
          ? result.verdict!
          : 'Resultado final recebido do backend.',
      timestamp: result.progress != null
          ? 'Progresso atual: ${result.progress}%'
          : 'Resultado concluído',
      labels: labels.isEmpty ? const ['Resultado', 'Análise'] : labels,
    );
  }

  @override
  Widget build(BuildContext context) {
    final probability = _clampPercentage(score);
    final effectiveSummary = summary;
    final effectiveTimestamp = timestamp;
    final effectiveLabels = labels;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 28,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Último scan',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.22),
                  ),
                ),
                child: const Text(
                  'ANÁLISE RECENTE',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatPercentage(probability),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        height: 0.95,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Nível de confiança',
                      style: TextStyle(
                        color: AppColors.neutralLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.auto_graph,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'CERTEZA',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            effectiveSummary,
            style: const TextStyle(
              color: AppColors.neutralLight,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final label in effectiveLabels) _LatestScanTag(label: label),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            effectiveTimestamp,
            style: const TextStyle(
              color: AppColors.neutral,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LatestScanTag extends StatelessWidget {
  final String label;

  const _LatestScanTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color? color;

  const _StatusBanner({
    required this.title,
    required this.message,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: effectiveColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: effectiveColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.neutralLight,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

double _clampPercentage(double? value) {
  final normalized = value ?? 0.0;
  if (normalized.isNaN || normalized.isInfinite) {
    return 0.0;
  }
  return normalized.clamp(0.0, 100.0);
}

String _formatPercentage(double value) {
  final safeValue = _clampPercentage(value);
  final hasDecimals = safeValue.truncateToDouble() != safeValue;
  return '${safeValue.toStringAsFixed(hasDecimals ? 1 : 0)}%';
}

class _UploadFab extends StatelessWidget {
  final VoidCallback onTap;

  const _UploadFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: AppColors.background, size: 28),
      ),
    );
  }
}
