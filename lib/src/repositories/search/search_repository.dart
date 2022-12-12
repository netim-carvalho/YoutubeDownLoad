import 'package:curso_youtube/src/model/video.dart';

abstract class SearchRepository {
  Future<List<Video>> searchVideos(String search);

  Future<List<Video>> nextPage();

  Future<List> suggestionsVideos(String search);
}
