import 'dart:convert';

import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/helpers/cache_invalidator.dart';
import 'package:calibre_carte/homepage.dart';
import 'package:calibre_carte/providers/color_theme_provider.dart';
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
  Function logout;

  DownloadingProgress(
      this.relativePath, this.fileName, this.oldContext, this.logout);

  @override
  _DownloadingProgressState createState() => _DownloadingProgressState();
}

class _DownloadingProgressState extends State<DownloadingProgress> {
  String progress = "Progress  0%";
  bool downloading = false;
  double perc = 0.0;
  String url = "https://content.dropboxapi.com/2/files/download";
  CancelToken cancelToken = CancelToken();

  Future downloadFile() async {
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
//        print(e.message);
        progress = "ERROR";
      });
      if (e.message == "cancelled") {
        //update to handle 401
        return e;
      } else {
        return e.response.statusCode;
      }
    }
  }

  void _cancelDownload() {
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
    downloadFile().then((value) {
      if (value == 401) {
        //update to handle 401 errors
        widget.logout();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return MyHomePage();
        }));
      } else if (value == 0) {
        Navigator.of(context).pop("Download Finished!");
      } else {
        Navigator.pop(context, "Download Failed.");
      }
    });
  }

  textScaleFactor(BuildContext context) {
    if (MediaQuery.of(context).size.height > 610) {
      return MediaQuery.of(context).textScaleFactor.clamp(0.6, 1.0);
    } else {
      return MediaQuery.of(context).textScaleFactor.clamp(0.6, 0.85);
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorTheme colorTheme=Provider.of(context);
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: textScaleFactor(context)),
      child: WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog( backgroundColor: colorTheme.alertBoxColor,
          title: Text(
            "Your progress",
            style: TextStyle(fontSize: 10, color: colorTheme.headerText),
          ),
          contentPadding:
              EdgeInsets.only(top: 0, left: 23, right: 23, bottom: 23),
          content: Container(
            height: 100,
            child: Column(
              children: <Widget>[
                AnimatedProgressbar(
                  value: perc,
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    _cancelDownload();
                  },
                  child: Container(
                      padding: EdgeInsets.only(
                          top: 25, left: 23, right: 23, bottom: 10),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: colorTheme.headerText,
                            fontSize: 15),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
