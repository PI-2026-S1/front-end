import 'package:deepfakedetectorfront/app/home/home_controller.dart';
import 'package:deepfakedetectorfront/components/greeting_section.dart';
import 'package:deepfakedetectorfront/components/recent_activity_section.dart';
import 'package:deepfakedetectorfront/components/safe_score_card.dart';
import 'package:deepfakedetectorfront/components/stats_row.dart';
import 'package:deepfakedetectorfront/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final HomeController controller;

  const HomePage({super.key, this.controller = const HomeController()});

  static const _activityItems = [
    ActivityItem(
      filename: 'video.mp4',
      subtitle: 'Finalizado • Há 5 min',
      status: 'VERIFIED',
      statusColor: AppColors.success,
    ),
    ActivityItem(
      filename: 'clip.mov',
      subtitle: 'Processando • 88%',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingSection(),
              const SizedBox(height: 24),
              const SafeScoreCard(score: 0.67),
              const SizedBox(height: 16),
              const StatsRow(mediasScan: 1284, threats: 3),
              const SizedBox(height: 24),
              RecentActivitySection(
                items: _activityItems,
                onViewAll: () => controller.showPrimaryActionSnack(context),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 24,
          right: 16,
          child: GestureDetector(
            onTap: () => controller.showPrimaryActionSnack(context),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.black, size: 28),
            ),
          ),
        ),
      ],
    );
  }
}