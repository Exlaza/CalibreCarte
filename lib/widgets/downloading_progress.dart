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
  String progress = "0%";
  bool downloading = false;
  String url = "https://content.dropboxapi.com/2/files/download";

  Future<void> downloadFile() async {
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
              progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
            });
          });
    } catch (e) {
//      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadFile().then((_){
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Progress: $progress'),
    );
  }
}