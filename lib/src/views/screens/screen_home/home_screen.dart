import 'package:curso_youtube/src/apis/api.dart';
import 'package:curso_youtube/src/apis/apy_yt.dart';
import 'package:curso_youtube/src/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:curso_youtube/src/blocs/favorite_bloc/favorite_event.dart';
import 'package:curso_youtube/src/blocs/favorite_bloc/favorite_state.dart';
import 'package:curso_youtube/src/blocs/video_bloc/video_bloc.dart';
import 'package:curso_youtube/src/blocs/video_bloc/video_event.dart';
import 'package:curso_youtube/src/blocs/video_bloc/video_state.dart';
import 'package:curso_youtube/src/helper/favorite_helper.dart';
import 'package:curso_youtube/src/model/video.dart';
import 'package:curso_youtube/src/repositories/download/download_repository_impl.dart';
import 'package:curso_youtube/src/repositories/favorite/favorite_repository_impl.dart';
import 'package:curso_youtube/src/repositories/search/search_repository_impl.dart';
import 'package:curso_youtube/src/views/screens/screen_favorites/favorites_screen.dart';
import 'package:curso_youtube/src/views/screens/screen_home/home_controller.dart';
import 'package:curso_youtube/src/views/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController homeController;

  @override
  void initState() {
    homeController = HomeController(FavoriteRepositoryImpl(FavoriteHelper()),
        SearchRepositoryImpl(Api()), ScrollController());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    homeController.downloadRepository =
        DownloadRepositoryImpl(Provider.of<ApiYt>(context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    homeController.bloc.add(LoadVideoEvent());
    homeController.bloc.close();
    homeController.favBloc.close();
    homeController.scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          "lib/src/images/youtube_logo.png",
          cacheHeight: 70,
        ),
        actions: [
          Center(
            child: BlocBuilder<FavoriteBloc, FavoriteState>(
              bloc: homeController.favBloc,
              builder: (context, state) {
                Map<String, Video> videos = state.favoritesVideos;
                return Text(
                  "${videos.length}",
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FavoritesScreen()));
              homeController.favBloc.add(LoadFavoriteEvent());
            },
            icon: const Icon(
              Icons.star,
            ),
          ),
          IconButton(
            onPressed: () async {
              String? result = await showSearch(
                context: context,
                delegate: Search(homeController.searchRepository),
              );
              if (result != null) {
                homeController.bloc.add(SearchVideoEvent(search: result));
                homeController.favBloc.add(LoadFavoriteEvent());
              }
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: BlocBuilder<VideoBloc, VideoState>(
        bloc: homeController.bloc,
        builder: (context, state) {
          if (state is VideoInitialState) {
            return RxBuilder(builder: (context) {
              return Center(
                child: homeController.bloc.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text(
                        "LISTA VAZIA",
                        style: TextStyle(color: Colors.white),
                      ),
              );
            });
          } else if (state is VideoSuccessState ||
              state is NextPageVideoSuccessState) {
            homeController.videos = state.videos;
            return homeController.videos.isEmpty
                ? const Center(
                    child: Text(
                      "Nenhum Video Encontrado",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Stack(
                    children: [
                      ListView.builder(
                        controller: homeController.scrollController,
                        itemCount: homeController.videos.length,
                        itemBuilder: (context, index) {
                          return videoTile(homeController.videos[index]);
                        },
                      ),
                      RxBuilder(
                        builder: (context) {
                          return homeController.bloc.isLoading.value
                              ? const Positioned(
                                  bottom: 10,
                                  left: 120,
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 5,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              : Container();
                        },
                      ),
                    ],
                  );
          } else if (state is VideoErrorState) {
            String? error = state.exceptionError;
            return Center(
              child: Text(
                "$error",
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget videoTile(Video video) {
    String videoIdAtual = "";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: RxBuilder(
              builder: (context) {
                if (homeController.playerVideo.value &&
                    videoIdAtual == video.id) {
                  return YoutubePlayer(
                      controller: homeController.playerController(video),
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.red,
                      progressColors: const ProgressBarColors(
                          backgroundColor: Colors.white,
                          bufferedColor: Colors.green,
                          handleColor: Colors.red,
                          playedColor: Colors.red));
                } else {
                  return GestureDetector(
                    onTap: () {
                      homeController.playerVideo.value = false;
                      homeController.playerVideo.value = true;
                      videoIdAtual = "";
                      videoIdAtual = video.id;
                    },
                    child: Stack(fit: StackFit.expand, children: [
                      Image.network(
                        video.thumb,
                        fit: BoxFit.cover,
                      ),
                      const Center(
                        child: SizedBox(
                          height: 350,
                          width: 350,
                          child: Icon(Icons.play_circle,
                              size: 100, color: Colors.white70),
                        ),
                      ),
                    ]),
                  );
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        video.title,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        video.channel,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<FavoriteBloc, FavoriteState>(
                  bloc: homeController.favBloc,
                  builder: (context, state) {
                    Map<String, Video> favoritesVideos = state.favoritesVideos;
                    return IconButton(
                      onPressed: () {
                        favoritesVideos.containsKey(video.id)
                            ? homeController.favBloc
                                .add(RemoveFavoriteEvent(video: video))
                            : homeController.favBloc
                                .add(AddFavoriteEvent(video: video));
                      },
                      color: Colors.white,
                      icon: Icon(favoritesVideos.containsKey(video.id)
                          ? Icons.star
                          : Icons.star_border),
                    );
                  }),
              Consumer<ApiYt>(
                builder: (context, apiYt, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    onPressed: () async {
                      switchModalBottomSheet(video);
                    },
                    child: const Icon(Icons.download),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void switchModalBottomSheet(Video video) {
    showModalBottomSheet(
        elevation: 1,
        context: context,
        builder: (context) {
          return SizedBox(
            height: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  enabled: true,
                  leading: const Icon(Icons.file_copy),
                  title: const Text("Tipo De Arquivo"),
                  trailing: RxBuilder(builder: (context) {
                    return DropdownButton<String>(
                      value: homeController.fileType.value,
                      onChanged: (value) {
                        homeController.fileType.value = value.toString();
                      },
                      items: const [
                        DropdownMenuItem<String>(
                          value: "video",
                          child: Text("Video"),
                        ),
                        DropdownMenuItem<String>(
                          value: "audio",
                          child: Text("Audio/Mp3"),
                        ),
                      ],
                      icon: const Icon(Icons.expand_circle_down_outlined),
                    );
                  }),
                ),
                RxBuilder(builder: (context) {
                  return ListTile(
                    enabled:
                        homeController.fileType.value == "video" ? true : false,
                    leading: const Icon(Icons.video_collection_outlined),
                    title: const Text("Resolução De Download"),
                    trailing: DropdownButton<String>(
                      value: homeController.resolution.value,
                      onChanged: homeController.fileType.value == "video"
                          ? (value) {
                              homeController.resolution.value =
                                  value.toString();
                            }
                          : null,
                      items: const [
                        DropdownMenuItem<String>(
                          value: "hd",
                          child: Text("HD"),
                        ),
                        DropdownMenuItem<String>(
                          value: "sd",
                          child: Text("SD"),
                        ),
                      ],
                      icon: const Icon(Icons.expand_circle_down_outlined),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      homeController.downloadRepository?.getApiUrl(
                          urlVideo:
                              "https://www.youtube.com/watch?v=${video.id}",
                          resolutionVideo: homeController.resolution.value,
                          titleVideo:
                              "${video.title} ${homeController.resolution.value}",
                          fileType: homeController.fileType.value);
                      downloadModalBottomSheet();
                    },
                    child: const Text(
                      "DOWNLOAD",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void downloadModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Baixando...",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Consumer<ApiYt>(builder: (context, controller, child) {
                      return Text(
                        "${controller.progress}%",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      );
                    }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 25,
                    bottom: 25,
                  ),
                  child: Consumer<ApiYt>(
                    builder: (context, controller, child) {
                      return LinearProgressIndicator(
                        minHeight: 7,
                        value: controller.progress / 100,
                      );
                    },
                  ),
                ),
                Consumer<ApiYt>(
                  builder: (context, controller, child) {
                    return Expanded(
                      child: Text(
                        controller.status,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
