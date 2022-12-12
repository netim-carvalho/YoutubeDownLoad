import 'package:curso_youtube/src/model/video.dart';

abstract class VideoEvent {}

class SearchVideoEvent extends VideoEvent {
  String search;

  SearchVideoEvent({required this.search});
}

class NextPageSearchVideoEvent extends VideoEvent {
  List<Video> videos;

  NextPageSearchVideoEvent({required this.videos});
}

class LoadVideoEvent extends VideoEvent {}
