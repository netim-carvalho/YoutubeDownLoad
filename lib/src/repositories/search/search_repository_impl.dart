import 'package:curso_youtube/src/apis/api.dart';
import 'package:curso_youtube/src/model/video.dart';
import 'package:curso_youtube/src/repositories/search/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final Api _api;

  SearchRepositoryImpl(this._api);

  @override
  Future<List<Video>> nextPage() {
    return _api.nextPage();
  }

  @override
  Future<List<Video>> searchVideos(String search) {
    return _api.searchVideos(search);
  }

  @override
  Future<List> suggestionsVideos(String search) {
    return _api.suggestionsVideos(search);
  }

}