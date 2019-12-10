import 'dart:convert';

import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/widgets/animated_progressbar.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DownloadingProgress extends StatefulWidget {
  String relativePath;
  String fileName;
  BuildContext oldContext;

  DownloadingProgress(this.relativePath, this.fileName, this.oldContext);

  @override
  _DownloadingProgressState createState() => _DownloadingProgressState();
}

class _DownloadingProgressState extends State<DownloadingProgress> {
  String progress = "Progress  0%";
  bool downloading = false;
  double perc = 0.0;
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
          perc = (rec / total);
          progress =
              "Progress  " + ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
      return true;
    } catch (e) {
      setState(() {
        progress="ERROR";
      });
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadFile().then((value) {
      Navigator.of(context).pop();
      if (value == false) {
        Scaffold.of(widget.oldContext).showSnackBar(SnackBar(
          content: Text("Download Error"),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Your progress", style: TextStyle(fontSize: 10),),
      contentPadding: EdgeInsets.only(top: 0, left: 23, right: 23, bottom: 23),
      content: AnimatedProgressbar(value: perc, height: 12,),
    );
  }
}
