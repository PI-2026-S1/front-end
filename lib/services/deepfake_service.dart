import 'package:deepfakedetectorfront/data/models/deepfake_models.dart';
import 'package:deepfakedetectorfront/data/models/video_upload_data.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class DeepfakeApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool isConnectionError;
  final Object? details;

  const DeepfakeApiException({
    required this.message,
    this.statusCode,
    this.isConnectionError = false,
    this.details,
  });

  factory DeepfakeApiException.connection([
    String message = 'Falha de conexão com o backend local.',
  ]) {
    return DeepfakeApiException(message: message, isConnectionError: true);
  }

  factory DeepfakeApiException.badRequest([
    String message = 'Arquivo inválido ou requisição incompleta.',
  ]) {
    return DeepfakeApiException(message: message, statusCode: 400);
  }

  factory DeepfakeApiException.notFound([
    String message = 'Job não encontrado.',
  ]) {
    return DeepfakeApiException(message: message, statusCode: 404);
  }

  factory DeepfakeApiException.server({
    required int statusCode,
    String? message,
    Object? details,
  }) {
    return DeepfakeApiException(
      message: message ?? 'Erro inesperado do servidor.',
      statusCode: statusCode,
      details: details,
    );
  }

  @override
  String toString() => message;
}

class DeepfakeService {
  static const String defaultBaseUrl = 'http://127.0.0.1:1234';

  final Dio _dio;

  DeepfakeService({Dio? dio, String baseUrl = defaultBaseUrl})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 30),
              headers: const {'Accept': 'application/json'},
            ),
          );

  Future<DeepfakeDetectResponse> uploadVideo(VideoUploadData videoData) async {
    try {
      final multipartFile = videoData.hasBytes
          ? MultipartFile.fromBytes(
              videoData.bytes!,
              filename: videoData.filename,
              contentType: _contentTypeFor(videoData.filename),
            )
          : await MultipartFile.fromFile(
              videoData.path!,
              filename: videoData.filename,
              contentType: _contentTypeFor(videoData.filename),
            );

      final response = await _dio.post<Map<String, dynamic>>(
        '/api/detect',
        data: FormData.fromMap(<String, dynamic>{'video': multipartFile}),
      );
      return DeepfakeDetectResponse.fromJson(_readJson(response.data));
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<DeepfakeStatusResponse> getStatus(String jobId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/status/$jobId',
      );
      return DeepfakeStatusResponse.fromJson(_readJson(response.data));
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<DeepfakeResultResponse> getResults(String jobId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/results/$jobId',
      );
      return DeepfakeResultResponse.fromJson(_readJson(response.data));
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<DeepfakeHealthResponse> checkHealth() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/api/health');
      return DeepfakeHealthResponse.fromJson(_readJson(response.data));
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Map<String, dynamic> _readJson(Map<String, dynamic>? data) {
    return data ?? <String, dynamic>{};
  }

  DeepfakeApiException _mapDioException(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final data = response?.data;
    final message =
        _extractMessage(data) ??
        error.message ??
        'Erro inesperado ao comunicar com a API.';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return DeepfakeApiException.connection();
      case DioExceptionType.badResponse:
        if (statusCode == 400) {
          return DeepfakeApiException.badRequest(message);
        }
        if (statusCode == 404) {
          return DeepfakeApiException.notFound(message);
        }
        return DeepfakeApiException.server(
          statusCode: statusCode ?? -1,
          message: message,
          details: data,
        );
      case DioExceptionType.cancel:
        return DeepfakeApiException.server(
          statusCode: statusCode ?? -1,
          message: 'Requisição cancelada.',
          details: data,
        );
      case DioExceptionType.unknown:
        return DeepfakeApiException.server(
          statusCode: statusCode ?? -1,
          message: message,
          details: data,
        );
    }
  }

  String? _extractMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      final message = data['detail'] ?? data['message'] ?? data['error'];
      if (message != null) {
        return message.toString();
      }
    }
    return null;
  }

  MediaType? _contentTypeFor(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    return switch (extension) {
      'mp4' => MediaType('video', 'mp4'),
      'mov' => MediaType('video', 'quicktime'),
      'avi' => MediaType('video', 'x-msvideo'),
      'mkv' => MediaType('video', 'x-matroska'),
      _ => null,
    };
  }
}
