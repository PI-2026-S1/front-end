class DeepfakeDetectResponse {
  final String jobId;
  final String status;

  const DeepfakeDetectResponse({required this.jobId, required this.status});

  factory DeepfakeDetectResponse.fromJson(Map<String, dynamic> json) {
    return DeepfakeDetectResponse(
      jobId: (json['job_id'] ?? json['jobId'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
    );
  }
}

class DeepfakeStatusResponse {
  final String jobId;
  final String status;
  final int? progress;

  const DeepfakeStatusResponse({
    required this.jobId,
    required this.status,
    required this.progress,
  });

  factory DeepfakeStatusResponse.fromJson(Map<String, dynamic> json) {
    return DeepfakeStatusResponse(
      jobId: (json['job_id'] ?? json['jobId'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      progress: _parseInt(json['progress']),
    );
  }
}

class DeepfakeResultResponse {
  final double? fakeProbability;
  final String verdict;
  final List<String> artifacts;
  final double? confidence;
  final String? modelUsed;

  const DeepfakeResultResponse({
    required this.fakeProbability,
    required this.verdict,
    required this.artifacts,
    required this.confidence,
    required this.modelUsed,
  });

  factory DeepfakeResultResponse.fromJson(Map<String, dynamic> json) {
    final resultJson = _asMap(json['results']) ?? json;
    final artifactsValue = resultJson['artifacts'] ?? json['artifacts'];
    return DeepfakeResultResponse(
      fakeProbability: _parseDouble(
        resultJson['fake_probability'] ??
            resultJson['fakeProbability'] ??
            json['fake_probability'] ??
            json['fakeProbability'],
      ),
      verdict: (resultJson['verdict'] ?? json['verdict'] ?? '').toString(),
      artifacts: artifactsValue is List
          ? artifactsValue.map((item) => item.toString()).toList()
          : const [],
      confidence: _parseDouble(resultJson['confidence'] ?? json['confidence']),
      modelUsed:
          (resultJson['model_used'] ??
                  resultJson['modelUsed'] ??
                  json['model_used'] ??
                  json['modelUsed'] ??
                  '')
              .toString(),
    );
  }
}

class DeepfakeHealthResponse {
  final String status;

  const DeepfakeHealthResponse({required this.status});

  bool get isHealthy => status.toLowerCase() == 'healthy';

  factory DeepfakeHealthResponse.fromJson(Map<String, dynamic> json) {
    return DeepfakeHealthResponse(status: (json['status'] ?? '').toString());
  }
}

class DeepfakeJobResult {
  final String jobId;
  final String status;
  final int? progress;
  final double? fakeProbability;
  final String? verdict;
  final double? confidence;
  final String? modelUsed;
  final List<String> artifacts;

  const DeepfakeJobResult({
    required this.jobId,
    required this.status,
    required this.progress,
    required this.fakeProbability,
    required this.verdict,
    required this.confidence,
    required this.modelUsed,
    required this.artifacts,
  });

  bool get isProcessing => _isProcessingStatus(status);

  bool get isCompleted => _isCompletedStatus(status);

  bool get isFailed => _isFailedStatus(status);

  factory DeepfakeJobResult.fromStatus(DeepfakeStatusResponse response) {
    return DeepfakeJobResult(
      jobId: response.jobId,
      status: response.status,
      progress: response.progress,
      fakeProbability: null,
      confidence: null,
      modelUsed: null,
      verdict: null,
      artifacts: const [],
    );
  }

  factory DeepfakeJobResult.fromAnalysis(
    DeepfakeStatusResponse statusResponse,
    DeepfakeResultResponse resultResponse,
  ) {
    return DeepfakeJobResult(
      jobId: statusResponse.jobId,
      status: statusResponse.status,
      progress: statusResponse.progress,
      fakeProbability: resultResponse.fakeProbability,
      verdict: resultResponse.verdict,
      confidence: resultResponse.confidence,
      modelUsed: resultResponse.modelUsed,
      artifacts: resultResponse.artifacts,
    );
  }
}

bool _isProcessingStatus(String status) {
  final normalized = status.toLowerCase();
  return normalized == 'processing' ||
      normalized == 'running' ||
      normalized == 'queued';
}

bool _isCompletedStatus(String status) {
  final normalized = status.toLowerCase();
  return normalized == 'completed' ||
      normalized == 'complete' ||
      normalized == 'done' ||
      normalized == 'success' ||
      normalized == 'finished';
}

bool _isFailedStatus(String status) {
  final normalized = status.toLowerCase();
  return normalized == 'failed' ||
      normalized == 'error' ||
      normalized == 'rejected';
}

int? _parseInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.toInt();
  }
  return int.tryParse(value.toString());
}

double? _parseDouble(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  return double.tryParse(value.toString());
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return null;
}
