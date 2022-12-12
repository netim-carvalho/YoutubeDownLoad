import 'package:curso_youtube/src/model/video.dart';

abstract class FavoriteState {
  Map<String, Video> favoritesVideos;

  FavoriteState({required this.favoritesVideos});
}

class FavoriteInitialState extends FavoriteState {
  FavoriteInitialState() : super(favoritesVideos: {});
}

class FavoriteLoadState extends FavoriteState {
  FavoriteLoadState({required Map<String, Video> favoritesVideos}) : super(favoritesVideos: favoritesVideos);
}

class FavoriteSuccessState extends FavoriteState {
  FavoriteSuccessState({required Map<String, Video> favoritesVideos})
      : super(favoritesVideos: favoritesVideos);
}
