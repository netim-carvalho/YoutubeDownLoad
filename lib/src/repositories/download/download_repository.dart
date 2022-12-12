abstract class DownloadRepository {
  Future<bool> getApiUrl(
      {required String urlVideo,
      required resolutionVideo,
      required String titleVideo,
      required String fileType});
}
