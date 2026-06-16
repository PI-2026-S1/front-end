import 'package:deepfakedetectorfront/data/models/deepfake_models.dart';

class DeepfakeState {
  final bool isInitializing;
  final bool isUploading;
  final bool isPolling;
  final bool isRestoring;
  final bool isHealthy;
  final String? currentJobId;
  final int? progress;
  final DeepfakeJobResult? result;
  final String? errorMessage;

  const DeepfakeState({
    required this.isInitializing,
    required this.isUploading,
    required this.isPolling,
    required this.isRestoring,
    required this.isHealthy,
    required this.currentJobId,
    required this.progress,
    required this.result,
    required this.errorMessage,
  });

  factory DeepfakeState.initial() {
    return const DeepfakeState(
      isInitializing: true,
      isUploading: false,
      isPolling: false,
      isRestoring: false,
      isHealthy: true,
      currentJobId: null,
      progress: null,
      result: null,
      errorMessage: null,
    );
  }

  bool get hasResult => result != null;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  bool get isBusy => isInitializing || isUploading || isPolling || isRestoring;

  DeepfakeState copyWith({
    bool? isInitializing,
    bool? isUploading,
    bool? isPolling,
    bool? isRestoring,
    bool? isHealthy,
    String? currentJobId,
    int? progress,
    DeepfakeJobResult? result,
    String? errorMessage,
    bool clearCurrentJobId = false,
    bool clearProgress = false,
    bool clearResult = false,
    bool clearErrorMessage = false,
  }) {
    return DeepfakeState(
      isInitializing: isInitializing ?? this.isInitializing,
      isUploading: isUploading ?? this.isUploading,
      isPolling: isPolling ?? this.isPolling,
      isRestoring: isRestoring ?? this.isRestoring,
      isHealthy: isHealthy ?? this.isHealthy,
      currentJobId: clearCurrentJobId
          ? null
          : (currentJobId ?? this.currentJobId),
      progress: clearProgress ? null : (progress ?? this.progress),
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
