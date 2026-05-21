import 'package:deepfakedetectorfront/utils/app_colors.dart';
import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  final int mediasScan;
  final int threats;

  const StatsRow({
    super.key,
    this.mediasScan = 1284,
    this.threats = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.perm_media_outlined,
            label: 'MÍDIAS SCAN',
            value: _formatNumber(mediasScan),
            badge: '?',
            badgeColor: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.security_outlined,
            label: 'THREATS',
            value: threats.toString().padLeft(2, '0'),
            badge: 'BLOQUEADAS',
            badgeColor: AppColors.danger,
          ),
        ),
      ],
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      final parts = n.toString().split('');
      parts.insert(parts.length - 3, ',');
      return parts.join();
    }
    return n.toString();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String badge;
  final Color badgeColor;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.badge,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondary.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.secondary, size: 15),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.neutral,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            badge,
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}