import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/helpers/data_provider.dart';
import 'package:calibre_carte/models/data.dart';
import 'package:flutter/material.dart';

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

  Future<void> bookDownloader(fileName) {

    showDialog(
        context: context,
        builder: (_) {
          return DownloadingProgress(widget.relativePath, fileName);
        }).then((_){
          Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = getBookDataFormats();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AlertDialog(
            title: Text("Select Format"),
            content: Column(
              children: dataFormatsFileNameMap.map((element) {
                return FlatButton(
                  child: Text(element["format"]),
                  onPressed: () {
                    bookDownloader(element["name"]);
                  },
                );
              }).toList(),
              mainAxisSize: MainAxisSize.min,
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
