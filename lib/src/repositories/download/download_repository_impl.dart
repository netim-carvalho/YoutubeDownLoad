import 'package:curso_youtube/src/apis/apy_yt.dart';
import 'package:curso_youtube/src/repositories/download/download_repository.dart';

class DownloadRepositoryImpl implements DownloadRepository {
  //final BuildContext context;
  late final ApiYt apiYt;

  DownloadRepositoryImpl(this.apiYt);

  @override
  Future<bool> getApiUrl({required String urlVideo,
    required String titleVideo,
    required resolutionVideo,

    required String fileType}) async {
    return await apiYt.getApiUrl(
        urlVideo: urlVideo,
        resolutionVideo
        : resolutionVideo,
        titleVideo: titleVideo,
        fileType: fileType);
  }
}
