import 'package:curso_youtube/src/model/video.dart';

abstract class FavoriteRepository {
  Future<Map<String, Video>> addFav(Video video);

  Future<Map<String, Video>> loadFavorites();

  Future<Map<String, Video>> removeFav(Video video);
}
