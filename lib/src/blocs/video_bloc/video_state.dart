import 'package:curso_youtube/src/model/video.dart';

abstract class VideoState {
  List<Video> videos;
  String? exceptionError;

  VideoState({required this.videos, this.exceptionError});
}

class VideoInitialState extends VideoState {
  VideoInitialState() : super(videos: []);
}

class VideoSuccessState extends VideoState {
  VideoSuccessState({required List<Video> videos}) : super(videos: videos);
}

class NextPageVideoSuccessState extends VideoState {
  NextPageVideoSuccessState({required List<Video> videos})
      : super(videos: videos);
}

class VideoErrorState extends VideoState {
  VideoErrorState({required String? exceptionError})
      : super(videos: [], exceptionError: exceptionError);
}
