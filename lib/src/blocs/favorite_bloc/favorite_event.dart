import '../../model/video.dart';

abstract class FavoriteEvent {}

class LoadFavoriteEvent extends FavoriteEvent {}

class AddFavoriteEvent extends FavoriteEvent {
  Video video;

  AddFavoriteEvent({required this.video});
}

class RemoveFavoriteEvent extends FavoriteEvent {
  Video video;

  RemoveFavoriteEvent({required this.video});
}
