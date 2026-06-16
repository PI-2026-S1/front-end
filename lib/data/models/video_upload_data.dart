class VideoUploadData {
  final String filename;
  final List<int>? bytes;
  final String? path;

  const VideoUploadData({required this.filename, this.bytes, this.path})
    : assert(
        bytes != null || path != null,
        'bytes ou path devem ser informados',
      );

  bool get hasBytes => bytes != null && bytes!.isNotEmpty;
  bool get hasPath => path != null && path!.isNotEmpty;
}
