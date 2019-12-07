import 'dart:convert';

import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';


class DownloadingProgress extends StatefulWidget {
  String relativePath;
  String fileName;

  DownloadingProgress(this.relativePath, this.fileName);

  @override
  _DownloadingProgressState createState() => _DownloadingProgressState();
}

class _DownloadingProgressState extends State<DownloadingProgress> {
  String progress = "Progress  0%";
  bool downloading = false;
  String url = "https://content.dropboxapi.com/2/files/download";

  Future<bool> downloadFile() async {
    BookDownloader bd = BookDownloader();
    String token = await bd.getTokenFromPreferences();
    String basePath = await bd.getSelectedLibPathFromSharedPrefs();
    String absPath = basePath + widget.relativePath + '/' + widget.fileName;
    String savePath = await bd.returnFileDirectory(widget.fileName);

    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Dropbox-API-Arg": jsonEncode({"path": absPath}),
    };
//    print('Coming till here');
    Dio d = Dio();
    try {
      await d.download(url, savePath, options: Options(headers: headers),
          onReceiveProgress: (rec, total) {
//            print("Rec: $rec, Total: $total");
            setState(() {
              progress = "Progress  "+((rec / total) * 100).toStringAsFixed(0) + "%";
            });
          });
      return true;
    } catch (e) {
setState(() {
  progress="Error downloading book: Check your internet connection";
});
      await Future.delayed(const Duration(seconds: 1));
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadFile().then((value){
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(progress),
    );
  }
}