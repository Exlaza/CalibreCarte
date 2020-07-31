import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/helpers/data_provider.dart';
import 'package:calibre_carte/models/data.dart';
import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import 'downloading_progress.dart';

class OpenFormatDialog extends StatefulWidget {
  final int bookId;
  final String relativePath;
  final BuildContext oldContext;

  OpenFormatDialog(this.bookId, this.relativePath, this.oldContext);

  @override
  _OpenFormatDialogState createState() => _OpenFormatDialogState();
}

class _OpenFormatDialogState extends State<OpenFormatDialog> {
  Future myFuture;
  List<Map<String, String>> dataFormatsFileNameMap = List();

  Future<void> getLocalBookFormats() async {
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
    List<Map<String, String>> filteredDataFormatsFileNameMap = List();
    BookDownloader bd = BookDownloader();
    for (int i = 0; i < dataFormatsFileNameMap.length; i++) {
      bool exists = await bd
          .checkIfDownloadedFileExists(dataFormatsFileNameMap[i]["name"]);
      if (exists) {
        filteredDataFormatsFileNameMap.add(dataFormatsFileNameMap[i]);
      }
    }

    setState(() {
      dataFormatsFileNameMap = filteredDataFormatsFileNameMap;
    });
  }

  Future<void> bookOpen(fileName) async {
    BookDownloader bd = BookDownloader();
    String fileDirectory = await bd.returnFileDirectoryExternal(fileName);

    String result = await OpenFile.open(fileDirectory);
    if (result == "No APP found to open this file。") {
//      print("No application found to open the file");
      Navigator.pop(context);
      Scaffold.of(widget.oldContext).showSnackBar(SnackBar(
        content: Text("No compatible app found."),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = getLocalBookFormats();
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
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaleFactor:
                    textScaleFactor(context)),
            child: AlertDialog( backgroundColor: colorTheme.alertBoxColor,
              title: Text("Select Format",style: TextStyle(color: colorTheme.headerText),),
              content: Column(
                children: dataFormatsFileNameMap.map((element) {
                  return FlatButton(
                    child: Text(element["format"],style: TextStyle(color: colorTheme.headerText)),
                    onPressed: () {
                      bookOpen(element["name"]);
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
