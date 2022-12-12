import 'dart:convert';

import 'package:curso_youtube/src/model/video.dart';
import 'package:http/http.dart' as http;

const API_KEY = "AIzaSyBAVpo3hFvn0DQnyvURMFRioLtPp9jHdbY";

class Api {
  String? _search;
  String? _nextToken;

  Future<List<Video>> searchVideos(String search) async {
    _search = search;
    http.Response response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"));
    switch (response.statusCode) {
      case 200:
        return decode(response);
      default:
        throw Exception(response.reasonPhrase);
    }
  }

  Future<List<Video>> nextPage() async {
    http.Response response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"));
    switch (response.statusCode) {
      case 200:
        return decode(response);
      default:
        throw Exception(response.reasonPhrase);
    }
  }

  List<Video> decode(http.Response response) {
    var decoded = json.decode(response.body);
    _nextToken = decoded["nextPageToken"];
    List<Video> videos = decoded["items"].map<Video>((map) {
      //print(map.toString());
      return Video.fromJson(map);
    }).toList();
    return videos;
  }

  Future<List> suggestionsVideos(String search) async {
    http.Response response = await http.get(Uri.parse(
        "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"));
    if (response.statusCode == 200) {
      return json.decode(response.body)[1].map((map) {
        return map[0];
      }).toList();
    } else {
      throw Exception("Failed to load Suggestions");
    }
  }
}
