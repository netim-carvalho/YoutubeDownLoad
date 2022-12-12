import 'package:curso_youtube/src/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:curso_youtube/src/blocs/favorite_bloc/favorite_event.dart';
import 'package:curso_youtube/src/blocs/favorite_bloc/favorite_state.dart';
import 'package:curso_youtube/src/helper/favorite_helper.dart';
import 'package:curso_youtube/src/model/video.dart';
import 'package:curso_youtube/src/repositories/favorite/favorite_repository_impl.dart';
import 'package:curso_youtube/src/views/screens/screen_favorites/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoriteController favoriteController;

  @override
  void initState() {
    // TODO: implement initState
    favoriteController =
        FavoriteController(FavoriteRepositoryImpl(FavoriteHelper()));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    favoriteController.favoriteBloc.add(LoadFavoriteEvent());
    favoriteController.favoriteBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
          bloc: favoriteController.favoriteBloc,
          builder: (context, state) {
            Map<String, Video> favoritesVideos = state.favoritesVideos;
            if (state.favoritesVideos.isNotEmpty) {
              return ListView(
                children: favoritesVideos.values.map((video) {
                  return InkWell(
                      onLongPress: () {
                        if (favoritesVideos.containsKey(video.id)) {
                          favoriteController.favoriteBloc
                              .add(RemoveFavoriteEvent(video: video));
                        }
                      },
                      onTap: () {},
                      child: Row(
                        children: [
                          Image.network(video.thumb,
                              cacheHeight: 70, cacheWidth: 70),
                          Expanded(
                            child: Text(
                              video.title,
                              maxLines: 2,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ));
                }).toList(),
              );
            } else {
              return const Center(
                child: Text(
                  "Sem Favoritos",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            }
          }),
    );
  }
}
