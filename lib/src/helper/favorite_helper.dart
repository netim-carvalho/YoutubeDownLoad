import 'dart:convert';

import 'package:curso_youtube/src/model/video.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteHelper {
  Map<String, Video> _favorites = {};

  FavoriteHelper() {
    SharedPreferences.getInstance().then((preferences) {
      if (preferences.getKeys().contains("favorites")) {
        _favorites =
            json.decode(preferences.getString("favorites")!).map((k, v) {
          return MapEntry(k, Video.fromJson(v));
        }).cast<String, Video>();
      }
    });
  }

  /*void toggleFavorite(Video video) {
    if (_favorites.containsKey(video.id)) {
      _favorites.remove(video.id);
    } else {
      _favorites[video.id] = video;
    }
    _favoriteController.sink.add(_favorites);
    _saveFav();
  }
   */

  Future<Map<String, Video>> removeFav(Video video) {
    if (_favorites.containsKey(video.id)) {
      _favorites.remove(video.id);
    }
    _saveFav();
    return loadFavorites();
  }

  Future<Map<String, Video>> addFav(Video video) {
    if (!_favorites.containsKey(video.id)) {
      _favorites[video.id] = video;
    }
    _saveFav();
    return loadFavorites();
  }

  Future<Map<String, Video>> loadFavorites() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("favorites")) {
      _favorites = json.decode(preferences.getString("favorites")!).map((k, v) {
        return MapEntry(k, Video.fromJson(v));
      }).cast<String, Video>();
    }
    return _favorites;
  }

  _saveFav() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("favorites", jsonEncode(_favorites));
    loadFavorites();
  }
}
