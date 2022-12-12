import 'package:curso_youtube/src/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:curso_youtube/src/blocs/favorite_bloc/favorite_event.dart';
import 'package:curso_youtube/src/repositories/favorite/favorite_repository.dart';

class FavoriteController {
  final FavoriteRepository favoriteRepository;
  late FavoriteBloc favoriteBloc;

  FavoriteController(this.favoriteRepository) {
    favoriteBloc = FavoriteBloc(favoriteRepository);
    favoriteBloc.add(LoadFavoriteEvent());
  }
}
