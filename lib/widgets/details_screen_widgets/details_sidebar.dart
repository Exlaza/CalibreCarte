import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:calibre_carte/widgets/details_screen_widgets/open_format_dialog.dart';
import 'package:calibre_carte/widgets/details_screen_widgets/select_format_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_html/style.dart';

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
    ColorTheme colorTheme = Provider.of<ColorTheme>(context);
    var width = MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width / 1.5;
    Widget descriptionPopup() {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.6, 0.85)),
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.2),
          floatingActionButton: FloatingActionButton(
              backgroundColor: colorTheme.appBarColor,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: colorTheme.descriptionArrow,
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
        ),
      );
    }

    textScaleFactor(BuildContext context) {
      if (MediaQuery.of(context).size.height > 610) {
        return MediaQuery.of(context).textScaleFactor.clamp(0.6, 1.0);
      } else {
        return MediaQuery.of(context).textScaleFactor.clamp(0.6, 0.85);
      }
    }

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: textScaleFactor(context)),
      child: Container(
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
                            SelectFormatDialog(bookId, bookDetails.path))
                    .then((val) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(val),
                  ));
                  checkCopies();
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                      border: colorTheme.darkMode
                          ? Border(
                              top: BorderSide.none,
                              left: BorderSide.none,
                              right: BorderSide.none,
                              bottom: BorderSide(width: 1, color: Colors.white),
                            )
                          : Border.all(width: 1, color: Colors.white),
                      color: colorTheme.descriptionIconColor
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
                showDialog(
                    context: context, builder: (_) => descriptionPopup());
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
                    border: colorTheme.darkMode
                        ? Border(
                            top: BorderSide.none,
                            left: BorderSide.none,
                            right: BorderSide.none,
                            bottom: BorderSide(width: 1, color: Colors.white),
                          )
                        : Border.all(width: 1, color: Colors.white),
                    color: colorTheme.descriptionIconAltColor,
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
                          builder: (_) => OpenFormatDialog(
                              bookId, bookDetails.path, context));
                    })
                  : (() => {}),
              child: Container(
                padding: EdgeInsets.all(10),
                // TODO: change sizes

                width: width,
                height: totalHeight / 4,
//              padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: colorTheme.darkMode
                      ? Border(
                          top: BorderSide.none,
                          left: BorderSide.none,
                          right: BorderSide.none,
                          bottom: BorderSide(width: 1, color: Colors.white),
                        )
                      : Border.all(width: 1, color: Colors.white),
                  color: colorTheme.descriptionIconColor,
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
                    border: colorTheme.darkMode
                        ? Border(
                            top: BorderSide.none,
                            left: BorderSide.none,
                            right: BorderSide.none,
                            bottom: BorderSide.none,
                          )
                        : Border.all(width: 1, color: Colors.white),
                    color: colorTheme.descriptionIconAltColor,
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
      ),
    );
  }
}
