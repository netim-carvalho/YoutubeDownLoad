import 'package:bloc/bloc.dart';
import 'package:curso_youtube/src/blocs/favorite_bloc/favorite_state.dart';
import 'package:curso_youtube/src/repositories/favorite/favorite_repository.dart';

import 'favorite_event.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _favoriteRepository;

  FavoriteBloc(this._favoriteRepository) : super(FavoriteInitialState()) {
    //_inputFavoriteController.stream.listen(_mapEventToState);
    on<LoadFavoriteEvent>(
      (event, emit) async => emit(FavoriteLoadState(
          favoritesVideos: await _favoriteRepository.loadFavorites())),
    );
    on<AddFavoriteEvent>(
      (event, emit) async => emit(FavoriteSuccessState(
          favoritesVideos: await _favoriteRepository.addFav(event.video))),
    );
    on<RemoveFavoriteEvent>((event, emit) async => emit(FavoriteSuccessState(
        favoritesVideos: await _favoriteRepository.removeFav(event.video))));
  }

/*
  _mapEventToState(FavoriteEvent event) {
    Map<String, Video> videos = {};
    if (event is LoadFavoriteEvent) {
      _outputFavoriteController.add(FavoriteInitialState());
    } else if (event is FavoriteSuccessState) {
      videos = _repository.loadFavorites();
    } else if (event is AddFavoriteEvent) {
      videos = _repository.addFav(event.video);
    } else if (event is RemoveFavoriteEvent) {
      videos = _repository.removeFav(event.video);
    }
    _outputFavoriteController.add(FavoriteSuccessState(videos: videos));
  }

   */
}
