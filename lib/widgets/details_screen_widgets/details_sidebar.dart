import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/widgets/details_screen_widgets/open_format_dialog.dart';
import 'package:calibre_carte/widgets/details_screen_widgets/select_format_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsSidebar extends StatelessWidget {
  final totalHeight;
  final bookId;
  final bookDetails;
  final bookComments;
  final bool downloaded;
  final dataFormatsFileNameMap;
  final Function checkCopies;

  var color = Color(0xffFED962);
  var altColor = Color(0xffFFE06F);
  var activeIcon = Colors.white;
  var inactiveIcon = Colors.grey.withOpacity(0.3);

  DetailsSidebar(
      {this.dataFormatsFileNameMap,
      this.downloaded,
      this.totalHeight,
      this.bookId,
      this.bookComments,
      this.bookDetails,
      this.checkCopies});

  deleteAllLocalCopies() async {
    BookDownloader bd = BookDownloader();
    for (int i = 0; i < dataFormatsFileNameMap.length; i++) {
      bool op = await bd.checkAndDeleteIfDownloadedFilesExists(
          dataFormatsFileNameMap[i]['name']);
    }
    checkCopies();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width / 1.5;
    Widget descriptionPopup() {
      return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.2),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff002242),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xffFED962),
            )),
        body: Container(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Container(
                child: bookComments != null
                    ? Html(
                        data: bookComments.text,
                        defaultTextStyle: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            color: Colors.white))
                    : Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Text(
                          'No description',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              color: Colors.white),
                        ),
                      ),
              )),
        ),
      );
    }

    return Container(
      // TODO: change sizes

      width: width,
      height: totalHeight,
      color: Colors.black.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              showDialog(
                      context: context,
                      builder: (_) =>
                          SelectFormatDialog(bookId, bookDetails.path, context))
                  .then((_) {
                checkCopies();
              });
            },
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.white),
                    color: color
//                  boxShadow: [BoxShadow(blurRadius: 10)],
                    ),
                padding: EdgeInsets.all(10),
                // TODO: change sizes

                width: width,
                height: totalHeight / 4,
                child: IconButton(
                  icon: Icon(
                    Icons.file_download,
                    color: activeIcon,
                  ),
                  iconSize: 40,
                )),
          ),
          GestureDetector(
            onTap: () {
//              print("describe");
              showDialog(context: context, builder: (_) => descriptionPopup());
            },
            child: Tooltip(
              message: "Open book description",
              child: Container(
                padding: EdgeInsets.all(10),
                // TODO: change sizes

                width: width,
                height: totalHeight / 4,
//              padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                  color: altColor,
//                boxShadow: [BoxShadow(blurRadius: 10)],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.description,
                    color: activeIcon,
                  ),
                  iconSize: 40,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: downloaded
                ? (() {
                    showDialog(
                        context: context,
                        builder: (_) =>
                            OpenFormatDialog(bookId, bookDetails.path,context));
                  })
                : (() => {}),
            child: Container(
              padding: EdgeInsets.all(10),
              // TODO: change sizes

              width: width,
              height: totalHeight / 4,
//              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white),
                color: color,
//                boxShadow: [BoxShadow(blurRadius: 10)],
              ),
              child: IconButton(
                icon: Icon(Icons.chrome_reader_mode,
                    color: downloaded ? activeIcon : inactiveIcon),
                iconSize: 40,
              ),
            ),
          ),
          GestureDetector(
            onTap: downloaded
                ? (() async {
                    deleteAllLocalCopies();
                  })
                : (() => {}),
            child: Container(
              padding: EdgeInsets.all(10),
              // TODO: change sizes

              width: width,
              height: totalHeight / 4,
//              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                  color: altColor,
                  boxShadow: [
//                BoxShadow(blurRadius: 10),
                  ]),
              child: IconButton(
                icon: Icon(Icons.delete,
                    color: downloaded ? activeIcon : inactiveIcon),
                iconSize: 40,
              ),
            ),
          )
        ],
      ),
    );
  }
}
