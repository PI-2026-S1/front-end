import 'dart:async';
import 'package:deepfakedetectorfront/app/deepfake_state.dart';
import 'package:deepfakedetectorfront/data/models/deepfake_models.dart';
import 'package:deepfakedetectorfront/data/repositories/deepfake_repository.dart';
import 'package:deepfakedetectorfront/data/models/video_upload_data.dart';
import 'package:deepfakedetectorfront/services/deepfake_service.dart';
import 'package:flutter/foundation.dart';

class DeepfakeController extends ChangeNotifier {
  final DeepfakeRepository _repository;
  DeepfakeState _state = DeepfakeState.initial();
  Timer? _pollingTimer;
  int _requestVersion = 0;

  DeepfakeController({DeepfakeRepository? repository})
    : _repository =
          repository ?? DeepfakeRepository(service: DeepfakeService());

  DeepfakeState get state => _state;

  Future<void> initialize() async {
    _requestVersion += 1;
    final requestId = _requestVersion;

    // --- DEBUG ---
    print(
      "DEBUG [Req $requestId]: Iniciando verificação de saúde e job anterior...",
    );

    _setState(
      _state.copyWith(
        isInitializing: true,
        isRestoring: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final health = await _repository.checkHealth();

      // --- DEBUG ---
      print("DEBUG [Req $requestId]: Health check status: ${health.isHealthy}");

      if (requestId != _requestVersion) return;
      _setState(_state.copyWith(isHealthy: health.isHealthy));

      final lastJobId = await _repository.getLastJobId();

      // --- DEBUG ---
      print("DEBUG [Req $requestId]: LastJobId encontrado: $lastJobId");

      if (lastJobId == null || lastJobId.isEmpty) {
        _setState(
          _state.copyWith(
            isInitializing: false,
            isRestoring: false,
            clearErrorMessage: true,
          ),
        );
        return;
      }

      await _restoreJob(lastJobId, requestId);
    } on DeepfakeApiException catch (error) {
      // --- DEBUG ---
      print(
        "DEBUG [Req $requestId]: Erro na API durante inicialização: ${error.message} (Status: ${error.statusCode})",
      );

      if (requestId != _requestVersion) return;
      _setState(
        _state.copyWith(
          isInitializing: false,
          isRestoring: false,
          isHealthy: false,
          errorMessage: error.message,
        ),
      );
    } catch (e) {
      // --- DEBUG ---
      print("DEBUG [Req $requestId]: Erro inesperado: $e");

      if (requestId != _requestVersion) return;
      _setState(
        _state.copyWith(
          isInitializing: false,
          isRestoring: false,
          isHealthy: false,
          errorMessage: 'Falha inesperada ao inicializar a análise.',
        ),
      );
    }
  }

  Future<void> uploadVideo(VideoUploadData videoData) async {
    _cancelPolling();
    _requestVersion += 1;
    final requestId = _requestVersion;

    // --- DEBUG ---
    print(
      "DEBUG [Req $requestId]: Iniciando upload de vídeo. Tamanho/Nome: ${videoData.filename}",
    );

    _setState(
      _state.copyWith(
        isUploading: true,
        isRestoring: false,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await _repository.uploadVideo(videoData);

      // --- DEBUG ---
      print(
        "DEBUG [Req $requestId]: Upload concluído com sucesso. JobID recebido: ${response.jobId}",
      );

      if (requestId != _requestVersion) return;
      await _repository.saveLastJobId(response.jobId);

      // ... (restante do set state)

      await _startPolling(response.jobId, requestId);
    } on DeepfakeApiException catch (error) {
      // --- DEBUG ---
      print("DEBUG [Req $requestId]: Erro de API no upload: ${error.message}");

      if (requestId != _requestVersion) return;
      _setState(
        _state.copyWith(isUploading: false, errorMessage: error.message),
      );
    } catch (e) {
      // --- DEBUG ---
      print("DEBUG [Req $requestId]: Erro crítico no upload: $e");

      if (requestId != _requestVersion) return;
      _setState(
        _state.copyWith(
          isUploading: false,
          errorMessage: 'Não foi possível enviar o vídeo.',
        ),
      );
    }
  }

  Future<void> retryLastJob() async {
    await initialize();
  }

  Future<void> _restoreJob(String jobId, int requestId) async {
    _setState(
      _state.copyWith(
        isInitializing: false,
        isRestoring: true,
        currentJobId: jobId,
        clearErrorMessage: true,
      ),
    );

    try {
      final statusResponse = await _repository.getStatus(jobId);
      if (requestId != _requestVersion) {
        return;
      }

      final normalized = DeepfakeJobResult.fromStatus(statusResponse);
      _setState(
        _state.copyWith(
          isRestoring: false,
          currentJobId: jobId,
          progress: normalized.progress,
          result: normalized,
          clearErrorMessage: true,
        ),
      );

      if (normalized.isCompleted) {
        final results = await _repository.getResults(jobId);
        if (requestId != _requestVersion) {
          return;
        }
        _setState(
          _state.copyWith(
            isRestoring: false,
            currentJobId: jobId,
            progress: normalized.progress,
            result: DeepfakeJobResult.fromAnalysis(statusResponse, results),
            clearErrorMessage: true,
          ),
        );
        return;
      }

      if (normalized.isProcessing) {
        await _startPolling(jobId, requestId);
        return;
      }

      if (normalized.isFailed) {
        await _repository.clearLastJobId();
        _setState(
          _state.copyWith(
            isRestoring: false,
            errorMessage: 'O último job foi finalizado com erro.',
          ),
        );
      }
    } on DeepfakeApiException catch (error) {
      if (requestId != _requestVersion) {
        return;
      }
      if (error.statusCode == 404) {
        await _repository.clearLastJobId();
      }
      _setState(
        _state.copyWith(isRestoring: false, errorMessage: error.message),
      );
    }
  }

  Future<void> _startPolling(String jobId, int requestId) async {
    _cancelPolling();
    _setState(
      _state.copyWith(
        isPolling: true,
        currentJobId: jobId,
        clearErrorMessage: true,
      ),
    );

    Future<void> pollOnce() async {
      try {
        final statusResponse = await _repository.getStatus(jobId);
        if (requestId != _requestVersion) {
          return;
        }

        final normalized = DeepfakeJobResult.fromStatus(statusResponse);
        _setState(
          _state.copyWith(
            currentJobId: jobId,
            progress: normalized.progress,
            result: normalized,
            isPolling: normalized.isProcessing,
            clearErrorMessage: true,
          ),
        );

        if (normalized.isCompleted) {
          _pollingTimer?.cancel();
          _pollingTimer = null;
          final results = await _repository.getResults(jobId);
          if (requestId != _requestVersion) {
            return;
          }
          _setState(
            _state.copyWith(
              isPolling: false,
              currentJobId: jobId,
              progress: normalized.progress,
              result: DeepfakeJobResult.fromAnalysis(statusResponse, results),
              clearErrorMessage: true,
            ),
          );
        } else if (normalized.isFailed) {
          _pollingTimer?.cancel();
          _pollingTimer = null;
          await _repository.clearLastJobId();
          _setState(
            _state.copyWith(
              isPolling: false,
              errorMessage: 'A análise falhou durante o processamento.',
            ),
          );
        }
      } on DeepfakeApiException catch (error) {
        if (requestId != _requestVersion) {
          return;
        }
        if (error.statusCode == 404) {
          await _repository.clearLastJobId();
        }
        _pollingTimer?.cancel();
        _pollingTimer = null;
        _setState(
          _state.copyWith(isPolling: false, errorMessage: error.message),
        );
      }
    }

    await pollOnce();
    if (requestId != _requestVersion) {
      return;
    }
    if (!_state.isPolling) {
      return;
    }

    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      unawaited(pollOnce());
    });
  }

  void _cancelPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    if (_state.isPolling) {
      _setState(_state.copyWith(isPolling: false));
    }
  }

  void _setState(DeepfakeState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelPolling();
    super.dispose();
  }
}
