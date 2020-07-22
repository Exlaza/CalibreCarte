import 'dart:io';

import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/helpers/cache_invalidator.dart';
import 'package:calibre_carte/helpers/data_provider.dart';
import 'package:calibre_carte/models/data.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'downloading_progress.dart';

class SelectFormatDialog extends StatefulWidget {
  int bookId;
  String relativePath;

  SelectFormatDialog(this.bookId, this.relativePath);

  @override
  _SelectFormatDialogState createState() => _SelectFormatDialogState();
}

class _SelectFormatDialogState extends State<SelectFormatDialog> {
  Future myFuture;
  List<Map<String, String>> dataFormatsFileNameMap = List();

  Future<void> deleteToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
  }

  Future<void> getBookDataFormats() async {
    List<Data> dataList = await DataProvider.getDataByBookID(widget.bookId);

    dataList.forEach((element) {
      String fileNameWithExtension =
          element.name + '.' + element.format.toLowerCase();
      Map<String, String> tempMap = {
        "format": element.format,
        "name": fileNameWithExtension
      };
      dataFormatsFileNameMap.add(tempMap);
    });
  }

  Future<void> bookDownloader(fileName, BuildContext context, Function logout) {
    showDialog(
        context: context,
        builder: (_) {
          return DownloadingProgress(
              widget.relativePath, fileName, context, logout);
        }).then((val) {
      Navigator.of(context).pop(val);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = getBookDataFormats();
  }

  Future<bool> checkNet() async {
    try {
      var result = await InternetAddress.lookup('www.google.com');
//      print("internet is $result");
      return true;
    } on SocketException catch (_) {
      return false;
    }
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
    Update update = Provider.of(context);
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaleFactor:
                    textScaleFactor(context)),
            child: AlertDialog(
              title: Text("Select Format"),
              content: Column(
                children: dataFormatsFileNameMap.map((element) {
                  return FlatButton(
                    child: Text(element["format"]),
                    onPressed: () {
                      checkNet().then((val) {
                        if (val == true) {
                          bookDownloader(element["name"], context, () {
                            deleteToken();
                            CacheInvalidator.invalidateImagesCache();
                            CacheInvalidator.invalidateDatabaseCache();
                            setState(() {
                              update.changeTokenState(false);
                              update.updateFlagState(true);
                            });
                          });
                        } else {
//                          print("came here");
                          Navigator.of(context).pop("No internet");
                        }
                      });
                    },
                  );
                }).toList(),
                mainAxisSize: MainAxisSize.min,
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
