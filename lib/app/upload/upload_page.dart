import 'package:deepfakedetectorfront/app/deepfake_controller.dart';
import 'package:deepfakedetectorfront/data/models/video_upload_data.dart';
import 'package:deepfakedetectorfront/utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatelessWidget {
  final DeepfakeController controller;

  const UploadPage({super.key, required this.controller});

  Future<void> _selectAndUpload(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['mp4', 'avi', 'mov', 'mkv'],
      withData: kIsWeb,
    );

    if (result == null) {
      return;
    }

    final file = result.files.single;
    final uploadData = kIsWeb
        ? VideoUploadData(filename: file.name, bytes: file.bytes)
        : VideoUploadData(filename: file.name, path: file.path);

    if ((uploadData.bytes == null || uploadData.bytes!.isEmpty) &&
        (uploadData.path == null || uploadData.path!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível ler o arquivo selecionado.'),
        ),
      );
      return;
    }

    await controller.uploadVideo(uploadData);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final state = controller.state;

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
                RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.cardBackground,
                  onRefresh: () async {
                    // Na UploadPage, geralmente recarregamos o estado inicial ou health
                    await controller.initialize();
                  },
                  child: SingleChildScrollView(
                    // physics é obrigatório para o RefreshIndicator funcionar em telas com pouco conteúdo
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        // ... (restante do seu código original do Column)
                        const Text(
                          'Enviar Vídeo',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Selecione um arquivo do seu dispositivo para iniciar a análise.',
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
                                  color: AppColors.cardBackgroundSoft
                                      .withOpacity(0.72),
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
                                        color: AppColors.primary.withOpacity(
                                          0.12,
                                        ),
                                        border: Border.all(
                                          color: AppColors.primary.withOpacity(
                                            0.20,
                                          ),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.18),
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
                                      'Upload do arquivo de vídeo',
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
                                      'Suporte para MP4, MOV, AVI e MKV.',
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
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: state.isUploading
                                          ? null
                                          : () => _selectAndUpload(context),
                                      child: state.isUploading
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors.background,
                                              ),
                                            )
                                          : const Text(
                                              'Selecionar vídeo',
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
                                'Os resultados mais recentes aparecem na aba de revisão e no painel inicial.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.neutralLight,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (state.hasError)
                                Text(
                                  state.errorMessage ??
                                      'Falha ao enviar vídeo.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 12,
                                  ),
                                )
                              else if (state.currentJobId != null)
                                Text(
                                  'Job atual: ${state.currentJobId}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
