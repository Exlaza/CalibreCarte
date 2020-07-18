import 'dart:convert';

import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/helpers/cache_invalidator.dart';
import 'package:calibre_carte/homepage.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/widgets/details_screen_widgets/animated_progressbar.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<int> downloadFile() async {
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
      return 0;
    } catch (e) {
      setState(() {
        progress = "ERROR";
      });
      return e.response.statusCode;
    }
  }

  void _cancelDownload(){
    cancelToken.cancel("cancelled");
  }

  Future<void> deleteToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Update update = Provider.of<Update>(widget.oldContext);
    downloadFile().then((value) {
      Navigator.of(context).pop();
      if (value == 401) {
        print("here");
        deleteToken();
        CacheInvalidator.invalidateImagesCache();
        CacheInvalidator.invalidateDatabaseCache();
        setState(() {
          update.changeTokenState(false);
          update.updateFlagState(true);
        });
        Navigator.of(context).pop();
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
