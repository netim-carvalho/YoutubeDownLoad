import 'package:curso_youtube/src/helper/favorite_helper.dart';
import 'package:curso_youtube/src/model/video.dart';
import 'package:curso_youtube/src/repositories/favorite/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteHelper favoriteHelper;

  FavoriteRepositoryImpl(this.favoriteHelper);

  @override
  Future<Map<String, Video>> addFav(Video video) {
    return favoriteHelper.addFav(video);
  }

  @override
  Future<Map<String, Video>> loadFavorites() {
    return favoriteHelper.loadFavorites();
  }

  @override
  Future<Map<String, Video>> removeFav(Video video) {
    return favoriteHelper.removeFav(video);
  }
}
