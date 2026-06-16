import 'package:deepfakedetectorfront/data/cache/deepfake_local_cache.dart';
import 'package:deepfakedetectorfront/data/models/deepfake_models.dart';
import 'package:deepfakedetectorfront/data/models/video_upload_data.dart';
import 'package:deepfakedetectorfront/services/deepfake_service.dart';

class DeepfakeRepository {
  final DeepfakeService _service;
  final DeepfakeLocalCache _cache;

  const DeepfakeRepository({
    required DeepfakeService service,
    DeepfakeLocalCache cache = const DeepfakeLocalCache(),
  }) : _service = service,
       _cache = cache;

  Future<DeepfakeDetectResponse> uploadVideo(VideoUploadData videoData) {
    return _service.uploadVideo(videoData);
  }

  Future<DeepfakeStatusResponse> getStatus(String jobId) {
    return _service.getStatus(jobId);
  }

  Future<DeepfakeResultResponse> getResults(String jobId) {
    return _service.getResults(jobId);
  }

  Future<DeepfakeHealthResponse> checkHealth() {
    return _service.checkHealth();
  }

  Future<void> saveLastJobId(String jobId) {
    return _cache.saveLastJobId(jobId);
  }

  Future<String?> getLastJobId() {
    return _cache.getLastJobId();
  }

  Future<void> clearLastJobId() {
    return _cache.clearLastJobId();
  }
}
