import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/helpers/data_provider.dart';
import 'package:calibre_carte/models/data.dart';
import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadIcon extends StatefulWidget {
  int bookId;

  DownloadIcon(this.bookId);

  @override
  _DownloadIconState createState() => _DownloadIconState();
}

class _DownloadIconState extends State<DownloadIcon> {
  Future<bool> checkIfLocalCopyExists() async {
    List<Data> dataList = await DataProvider.getDataByBookID(widget.bookId);
    List<Map<String, String>> dataFormatsFileNameMap = List();
    dataList.forEach((element) {
      String fileNameWithExtension =
          element.name + '.' + element.format.toLowerCase();
      Map<String, String> tempMap = {
        "format": element.format,
        "name": fileNameWithExtension
      };
      dataFormatsFileNameMap.add(tempMap);
    });

    BookDownloader bd = BookDownloader();
    for (int i = 0; i < dataFormatsFileNameMap.length; i++) {
      bool exists = await bd
          .checkIfDownloadedFileExists(dataFormatsFileNameMap[i]['name']);
      if (exists) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
//    print("Building download icon again");
    ColorTheme ct = Provider.of<ColorTheme>(context);
    return FutureBuilder(
        future: checkIfLocalCopyExists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return CircleAvatar(radius: 10,backgroundColor: ct.di,
                child: Icon(
                  Icons.done,
                  color: Colors.white,size: 15,
                ),
              );
            }
            else
              return Icon(
                  Icons.done,color: Colors.transparent,
//                  color: Colors.grey.withOpacity(0.3),size: 15,
              );
          } else
            return Icon(
              Icons.done,
              color: Colors.transparent,
            );
        });
  }
}
