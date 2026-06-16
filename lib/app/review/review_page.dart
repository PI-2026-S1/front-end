import 'package:deepfakedetectorfront/app/deepfake_controller.dart';
import 'package:deepfakedetectorfront/app/review/review_controller.dart';
import 'package:deepfakedetectorfront/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  final DeepfakeController deepfakeController;
  final ReviewController reviewController;

  const ReviewPage({
    super.key,
    required this.deepfakeController,
    this.reviewController = const ReviewController(),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: deepfakeController,
      builder: (context, _) {
        final state = deepfakeController.state;
        final result = state.result;

        final probability = _clampPercentage(result?.fakeProbability);
        final verdict = result?.verdict ?? 'Aguardando o resultado da análise.';
        final confidence = _clampPercentage(result?.confidence);
        final modelUsed = _normalizeLabel(result?.modelUsed, fallback: 'N/A');
        final jobId = _normalizeLabel(
          state.currentJobId ?? result?.jobId,
          fallback: 'N/A',
        );
        final progressValue = (probability / 100).clamp(0.0, 1.0);

        return SafeArea(
          child: Container(
            color: AppColors.background,
            child: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(-0.8, -0.9),
                          radius: 1,
                          colors: [
                            AppColors.primary.withOpacity(0.10),
                            AppColors.background,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      if (state.hasError) ...[
                        _InlineMessage(
                          title: 'Erro ao carregar a análise',
                          message: state.errorMessage ?? 'Tente novamente.',
                          actionLabel: 'Tentar novamente',
                          onPressed: deepfakeController.retryLastJob,
                        ),
                        const SizedBox(height: 18),
                      ],
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.12),
                              blurRadius: 24,
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
                                  'Nível de Confiança',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.auto_graph,
                                  color: AppColors.primary.withOpacity(0.92),
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
                                        value: progressValue,
                                        strokeWidth: 9,
                                        backgroundColor: AppColors.white
                                            .withOpacity(0.10),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppColors.primary.withOpacity(
                                                0.92,
                                              ),
                                            ),
                                        strokeCap: StrokeCap.round,
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _formatPercentage(probability),
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 44,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'CERTEZA',
                                          style: TextStyle(
                                            color: AppColors.white,
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
                            Text(
                              verdict,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.neutralLight,
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: [
                                if (state.isPolling || state.isRestoring)
                                  const _InfoChip(
                                    label: 'Processando',
                                    icon: Icons.hourglass_top,
                                  ),
                                if (result?.status.isNotEmpty == true)
                                  _InfoChip(
                                    label: result!.status,
                                    icon: Icons.signal_cellular_alt,
                                  ),
                                _InfoChip(
                                  label:
                                      'Confiança ${_formatPercentage(confidence)}',
                                  icon: Icons.verified_outlined,
                                ),
                                _InfoChip(
                                  label: modelUsed,
                                  icon: Icons.memory_outlined,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground.withOpacity(0.86),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.14),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.08),
                              blurRadius: 22,
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
                                    color: AppColors.primary.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.movie_creation_outlined,
                                    color: AppColors.primary,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Resumo da análise',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.currentJobId == null
                                  ? 'Envie um vídeo para visualizar o último resultado aqui.'
                                  : 'Job atual: ${state.currentJobId}',
                              style: const TextStyle(
                                color: AppColors.neutralLight,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.background.withOpacity(0.45),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.14),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Job ID',
                                    style: TextStyle(
                                      color: AppColors.neutralLight,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SelectableText(
                                    jobId,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 13,
                                      fontFamily: 'monospace',
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.background,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () => reviewController
                                  .showScoreExplanationDialog(context),
                              icon: const Icon(Icons.info_outline),
                              label: const Text(
                                'Por que este resultado?',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

String _normalizeLabel(String? value, {required String fallback}) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return fallback;
  }
  return trimmed;
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
        color: AppColors.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withOpacity(0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onPressed;

  const _InlineMessage({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.90),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent.withOpacity(0.20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 24),
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
                const SizedBox(height: 10),
                TextButton(onPressed: onPressed, child: Text(actionLabel)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
