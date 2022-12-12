import 'package:bloc/bloc.dart';
import 'package:curso_youtube/src/blocs/video_bloc/video_event.dart';
import 'package:curso_youtube/src/blocs/video_bloc/video_state.dart';
import 'package:curso_youtube/src/repositories/search/search_repository.dart';
import 'package:rx_notifier/rx_notifier.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final SearchRepository _searchRepository;
  RxNotifier<bool> isLoading = RxNotifier(false);

/*
  final StreamController<VideoEvent> _inputVideoController =
      StreamController<VideoEvent>.broadcast();
  final StreamController<VideoState> _outputVideoController =
      StreamController<VideoState>.broadcast();

  Sink<VideoEvent> get inputVideo => _inputVideoController.sink;

  Stream<VideoState> get stream => _outputVideoController.stream;
*/
  VideoBloc(this._searchRepository) : super(VideoInitialState()) {
    // _inputVideoController.stream.listen(_mapEventToState);
    on<LoadVideoEvent>(
      (event, emit) => emit(VideoInitialState()),
    );

    on<SearchVideoEvent>((event, emit) async {
      try {
        isLoading.value = true;
        emit(VideoSuccessState(
            videos: await _searchRepository.searchVideos(event.search)));
        isLoading.value = false;
      } catch (error) {
        isLoading.value = false;
        emit(VideoErrorState(exceptionError: error.toString()));
      }
    });

    on<NextPageSearchVideoEvent>((event, emit) async {
      try {
        isLoading.value = true;
        event.videos.addAll(await _searchRepository.nextPage());
        isLoading.value = false;
        emit(VideoSuccessState(videos: event.videos));
      } catch (error) {
        isLoading.value = false;
        emit(VideoErrorState(exceptionError: error.toString()));
      }
    });
  }
/*
  _mapEventToState(VideoEvent event) async {
    List<Video> videos;
    if (event is SearchVideoEvent) {
      try {
        videos = await _api.searchVideos(event.search);
        _outputVideoController.add(VideoSuccessState(videos: videos));
      } catch (error) {
        _outputVideoController
            .add(VideoErrorState(exceptionError: error.toString()));
      }
    } else if (event is NextPageSearchVideoEvent) {
      try {
        videos = event.videos;
        videos += await _api.nextPage();
        _outputVideoController.add(NextPageVideoSuccessState(videos: videos));
      } catch (error) {
        _outputVideoController
            .add(VideoErrorState(exceptionError: error.toString()));
      }
    } else if (event is LoadVideoEvent) {
      _outputVideoController.add(VideoInitialState());
    }
  }*/
}
