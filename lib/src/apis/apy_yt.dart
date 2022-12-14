import 'dart:convert';
import 'dart:io';

import 'package:curso_youtube/src/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ApiYt extends ChangeNotifier {
  Dio dio = Dio();
  String status = "";
  String fileType = "";
  double _progress = 0;
  bool downloading = false;
  bool downloaded = false;
  bool startGetApiUrl = false;
  bool okGetApiUrl = false;
  bool startGetPath = false;
  bool okGetPath = false;

  double get progress => _progress;

  Future<bool> getApiUrl(
      {required String urlVideo,
      required resolutionVideo,
      required String titleVideo,
      required String fileType}) async {
    this.fileType = fileType;
    http.Response response;
    startGetApiUrl = true;
    _progress = 0.0;
    status = "Buscando Url de Download...";
    notifyListeners();
    String url = urlVideo;
    String urlVideoDownload = "";
    if (this.fileType == "audio") {
      response = await http.get(Uri.parse(
          "https://apiyt.netimcarvalho.repl.co/downloadaudio?url=$url"));
    } else {
      response = await http.get(Uri.parse(
          "https://apiyt.netimcarvalho.repl.co/downloadvideo?url=$url&res=$resolutionVideo"));
    }
    switch (response.statusCode) {
      case 200:
        status = "Url Ok...";
        okGetApiUrl = true;
        notifyListeners();
        urlVideoDownload = decode(response);
        return await pathSaveVideo(
            fileName: Utils.removeEspecialCharacters(value: titleVideo),
            urlVideoDownload: urlVideoDownload);
      default:
        status = response.reasonPhrase ?? "Erro ao Buscar Url de Download";
        notifyListeners();
        throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> pathSaveVideo(
      {required String fileName, required String urlVideoDownload}) async {
    startGetPath = true;
    status = "Buscando Diretorio de Salvamento...";
    notifyListeners();
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage) &&
            await _requestPermission(Permission.manageExternalStorage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> folders = directory!.path.split("/");
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "Android") {
              newPath += "/$folder";
            } else {
              break;
            }
          }
          newPath = "$newPath/ytdown";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
        return false;
      }
      if (await directory.exists()) {
        File saveFile;
        if (fileType == "audio") {
          saveFile = File("${directory.path}/$fileName.mp3");
        } else {
          saveFile = File("${directory.path}/$fileName.mp4");
        }
        okGetPath = true;
        status = "Diretorio Ok...";
        notifyListeners();
        downloadVideo(
            urlVideoDownload: urlVideoDownload, filePath: saveFile.path);
        return true;
      }
    } catch (e) {
      status = "Erro de Diretorio: ${e.toString()}";
      throw e.toString();
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<String> downloadVideo(
      {required String filePath, required String urlVideoDownload}) async {
    String retorno = "";
    try {
      downloading = true;
      status = "Download Iniciado...";
      notifyListeners();
      await dio.download(urlVideoDownload, filePath,
          onReceiveProgress: (rec, total) {
        if (total != -1) {
          _progress = (rec / total * 100).floorToDouble();
          notifyListeners();
        }
      });
      status = "Download Finalizado...";
      startGetApiUrl = false;
      notifyListeners();
      return retorno;
    } catch (e) {
      status = "Erro ao baixar. Tente Novamente: ${e.toString()}";
      notifyListeners();
      throw e.toString();
    }
  }

  String decode(http.Response response) {
    var decoded = json.decode(response.body);
    if (fileType == "audio") {
      return decoded["url_audio"];
    } else {
      return decoded["url_video"];
    }
  }
}
