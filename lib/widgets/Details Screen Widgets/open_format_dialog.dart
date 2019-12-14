import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/helpers/data_provider.dart';
import 'package:calibre_carte/models/data.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import 'downloading_progress.dart';

class OpenFormatDialog extends StatefulWidget {
  final int bookId;
  final String relativePath;

  OpenFormatDialog(this.bookId, this.relativePath);

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
    String fileDirectory = await bd.returnFileDirectory(fileName);

    OpenFile.open(fileDirectory);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = getLocalBookFormats();
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
                    bookOpen(element["name"]);
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
