import 'package:deepfakedetectorfront/app/upload/upload_controller.dart';
import 'package:deepfakedetectorfront/utils/app_colors.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatelessWidget {
  final UploadController controller;

  const UploadPage({super.key, this.controller = const UploadController()});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.9, -0.8),
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
                  const Text(
                    'Enviar Vídeo / Imagem',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selecione um arquivo do seu dispositivo ou arraste e solte sua mídia aqui.',
                    style: TextStyle(
                      color: AppColors.neutralLight,
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 28,
                            horizontal: 18,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackgroundSoft.withOpacity(
                              0.72,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.14),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary.withOpacity(0.12),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(
                                        0.18,
                                      ),
                                      blurRadius: 22,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.cloud_upload_outlined,
                                  color: AppColors.primary,
                                  size: 42,
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                'Arraste e solte sua mídia aqui',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Ou clique para selecionar um arquivo do seu dispositivo.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.neutralLight,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.background,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 28,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () =>
                                    controller.showFilePickerSnack(context),
                                child: const Text(
                                  'Selecionar arquivo',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Formatos suportados: MP4, MOV, AVI, MKV',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.neutralLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tamanho máximo: 500 MB',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.neutral,
                            fontSize: 12,
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
  }
}
