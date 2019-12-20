import 'dart:convert';

import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/widgets/Details%20Screen%20Widgets/animated_progressbar.dart';
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
  CancelToken cancelToken = CancelToken();

  Future<bool> downloadFile() async {
    BookDownloader bd = BookDownloader();
    String token = await bd.getTokenFromPreferences();
    String basePath = await bd.getSelectedLibPathFromSharedPrefs();
    String absPath = basePath + widget.relativePath + '/' + widget.fileName;
    String savePath = await bd.returnFileDirectoryExternal(widget.fileName);

    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Dropbox-API-Arg": jsonEncode({"path": absPath}),
    };
//    print('Coming till here');
    Dio d = Dio();
    try {
      await d.download(url, savePath,
          options: Options(headers: headers),
          cancelToken: cancelToken, onReceiveProgress: (rec, total) {
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
        progress = "ERROR";
      });
      return false;
    }
  }

  void _cancelDownload(){
    cancelToken.cancel("cancelled");
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
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Text(
          "Your progress",
          style: TextStyle(fontSize: 10),
        ),
        contentPadding: EdgeInsets.only(top: 0, left: 23, right: 23, bottom: 23),
        content: Container( height: 100,
          child: Column(
            children: <Widget>[
              AnimatedProgressbar(
                value: perc,
                height: 12,
              ),
              InkWell(
                onTap: () {_cancelDownload(); },
                child: Container(
                    padding:
                        EdgeInsets.only(top: 25, left: 23, right: 23, bottom: 10),
                    child: Text("Cancel",style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xff002242),
                      fontSize: 15
                    ),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
