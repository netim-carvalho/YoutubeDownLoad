import 'package:curso_youtube/src/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:curso_youtube/src/blocs/favorite_bloc/favorite_event.dart';
import 'package:curso_youtube/src/blocs/video_bloc/video_bloc.dart';
import 'package:curso_youtube/src/blocs/video_bloc/video_event.dart';
import 'package:curso_youtube/src/model/video.dart';
import 'package:curso_youtube/src/repositories/download/download_repository.dart';
import 'package:curso_youtube/src/repositories/download/download_repository_impl.dart';
import 'package:curso_youtube/src/repositories/favorite/favorite_repository.dart';
import 'package:curso_youtube/src/repositories/search/search_repository.dart';
import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeController {
  final FavoriteRepository favoriteRepository;
  final SearchRepository searchRepository;
  DownloadRepository? downloadRepository;
  late final VideoBloc bloc;
  late final FavoriteBloc favBloc;
  late final ScrollController scrollController;
  List<Video> videos = [];

  RxNotifier<String> fileType = RxNotifier("video");
  RxNotifier<String> resolution = RxNotifier("hd");
  RxNotifier<bool> playerVideo = RxNotifier(false);

  HomeController(
      this.favoriteRepository, this.searchRepository, this.scrollController) {
    bloc = VideoBloc(searchRepository);
    bloc.add(LoadVideoEvent());
    favBloc = FavoriteBloc(favoriteRepository);
    favBloc.add(LoadFavoriteEvent());
    scrollController.addListener(infiniteScroll);
  }

  YoutubePlayerController playerController(Video video) {
    return YoutubePlayerController(
        initialVideoId: video.id,
        flags: const YoutubePlayerFlags(
            autoPlay: true, controlsVisibleAtStart: true, mute: false));
  }

  void infiniteScroll() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !bloc.isLoading.value) {
      bloc.add(NextPageSearchVideoEvent(videos: videos));
    }
  }
}
