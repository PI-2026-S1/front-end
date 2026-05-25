import 'package:deepfakedetectorfront/app/upload/upload_controller.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatelessWidget {
  final UploadController controller;

  const UploadPage({
    super.key,
    this.controller = const UploadController(),
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    /// RESPONSIVIDADE
    final bool isMobile = screenWidth < 950;

    return Scaffold(
      backgroundColor: const Color(0xFF050510),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// UPLOAD
                    _uploadArea(context, false),

                    const SizedBox(height: 20),

                    /// COMO FUNCIONA
                    _infoCard(
                      title: 'Como funciona nossa análise',
                      items: [
                        'Extração de frames',
                        'Análise de IA',
                        'Relatório completo',
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// IA AVANÇADA
                    _advancedCard(),

                    const SizedBox(height: 24),

                    /// DICAS
                    _tipsCard(),
                  ],
                )
              : Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _uploadArea(context, true),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Expanded(
                                  child: _infoCard(
                                    title: 'Como funciona nossa análise',
                                    items: [
                                      'Extração de frames',
                                      'Análise de IA',
                                      'Relatório completo',
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Expanded(
                                  child: _advancedCard(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    _tipsCard(),
                  ],
                ),
        ),
      ),
    );
  }

  /// =========================
  /// UPLOAD AREA
  /// =========================
  Widget _uploadArea(BuildContext context, bool desktopMode) {
    return Container(
      height: desktopMode ? double.infinity : null,
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B16),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_upload_outlined,
              color: Color(0xFF00E5FF),
              size: 110,
            ),

            const SizedBox(height: 30),

            const Text(
              'Arraste e solte seu vídeo aqui',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'ou clique para selecionar um arquivo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D9FF),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 22,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                controller.showFilePickerSnack(context);
              },
              child: const Text(
                'Selecionar vídeo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              'Formatos suportados: MP4, MOV, AVI, MKV',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Tamanho máximo: 500MB • Duração máxima: 30 minutos',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// CARD COMO FUNCIONA
  /// =========================
  Widget _infoCard({
    required String title,
    required List<String> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B16),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF00E5FF),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 24),

          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF00E5FF),
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        '${items.indexOf(e) + 1}',
                        style: const TextStyle(
                          color: Color(0xFF00E5FF),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Text(
                      e,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =========================
  /// CARD IA
  /// =========================
  Widget _advancedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B16),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'IA AVANÇADA',
              style: TextStyle(
                color: Color(0xFF00E5FF),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            SizedBox(height: 20),

            Text(
              'Usamos modelos de deep learning treinados com milhões de exemplos de deepfakes e vídeos reais.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// DICAS
  /// =========================
  Widget _tipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B16),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Dicas para melhores resultados',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 24),

          _TipItem(
            text: 'Use vídeos com boa qualidade (mínimo 720p)',
          ),

          _TipItem(
            text: 'Vídeos com rostos visíveis têm melhor precisão',
          ),

          _TipItem(
            text: 'Evite vídeos muito escuros ou com muitos cortes',
          ),

          _TipItem(
            text: 'Duração ideal: 10 segundos a 5 minutos',
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;

  const _TipItem({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF00E5FF),
            size: 24,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}