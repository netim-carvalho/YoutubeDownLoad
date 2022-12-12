class Video {
  final String id;
  final String title;
  final String thumb;
  final String channel;

  //final String duration;

  Video({
    required this.id,
    required this.title,
    required this.thumb,
    required this.channel,
    //  required this.duration
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("id")) {
      return Video(
        id: json["id"]["videoId"],
        title: json["snippet"]["title"],
        thumb: json["snippet"]["thumbnails"]["high"]["url"],
        channel: json["snippet"]["channelTitle"],
        //duration: json["contentDetails"]["duration"]
      );
    } else {
      return Video(
          id: json["videoId"],
          title: json["title"],
          thumb: json["thumb"],
          channel: json["channel"]
          //duration: json["duration"]
          );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "videoId": id,
      "title": title,
      "thumb": thumb,
      "channel": channel,
      //"duration": duration
    };
  }
}
