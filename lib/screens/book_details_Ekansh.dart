import 'dart:io';

import 'package:calibre_carte/helpers/authors_provider.dart';
import 'package:calibre_carte/helpers/book_author_link_provider.dart';
import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/helpers/comments_provider.dart';
import 'package:calibre_carte/helpers/data_provider.dart';
import 'package:calibre_carte/models/authors.dart';
import 'package:calibre_carte/models/books_authors_link.dart';
import 'package:calibre_carte/models/comments.dart';
import 'package:calibre_carte/models/data.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:calibre_carte/widgets/open_format_dialog.dart';
import 'package:calibre_carte/widgets/select_format_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../helpers/books_provider.dart';
import '../models/books.dart';

class BookDetailsScreenEkansh extends StatefulWidget {
  static const routeName = '/book-detailsbeta';
  final int bookId;

  BookDetailsScreenEkansh({this.bookId});

  @override
  _BookDetailsScreenEkanshState createState() =>
      _BookDetailsScreenEkanshState();
}

class _BookDetailsScreenEkanshState extends State<BookDetailsScreenEkansh> {
  Books bookDetails;
  Comments bookComments;
  Future myFuture;
  String localImagePath;
  String authorText;
  Future mySecondFuture;
  List<Map<String, String>> dataFormatsFileNameMap = List();

  Future<bool> checkIfLocalCopyExists() async {
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
//    print('Maybe coming here');

    BookDownloader bd = BookDownloader();
    for (int i = 0; i < dataFormatsFileNameMap.length; i++) {
      bool exists = await bd
          .checkIfDownloadedFileExists(dataFormatsFileNameMap[i]['name']);
      if (exists) {
        return true;
      }
    }
//    print('Coming here');
    return false;
  }

  deleteAllLocalCopies() async {
    BookDownloader bd = BookDownloader();
    for (int i = 0; i < dataFormatsFileNameMap.length; i++) {
      bool op = await bd.checkAndDeleteIfDownloadedFilesExists(
          dataFormatsFileNameMap[i]['name']);
    }
    setState(() {
      mySecondFuture = checkIfLocalCopyExists();
    });
  }

  Future<void> getBookDetails() async {
    bookDetails = await BooksProvider.getBookByID(widget.bookId, null);
//    print(widget.bookId);
    bookComments =
        await CommentsProvider.getCommentByBookID(widget.bookId, null);
    List<BooksAuthorsLink> bookAuthorsLinks =
        await BooksAuthorsLinksProvider.getAuthorsByBookID(widget.bookId);

    List<String> authors = List();
    for (int i = 0; i < bookAuthorsLinks.length; i++) {
      int authorID = bookAuthorsLinks[i].author;
      Authors author = await AuthorsProvider.getAuthorByID(authorID, null);
      authors.add(author.name);
    }

    authorText = authors.reduce((v, e) {
      return v + ', ' + e;
    });
  }

  @override
  void initState() {
    super.initState();
    myFuture = getBookDetails();
    mySecondFuture = checkIfLocalCopyExists();
  }

// TODO: change sizes
  Widget leftTile() {
    var width = MediaQuery.of(context).size.width / 1.5;
    var totalHeight = MediaQuery.of(context).size.height -
        appbar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    var bottomSize = totalHeight / 2;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // TODO: change sizes
          BookDetailsCoverImage(
              widget.bookId, bookDetails.path, bottomSize, width),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: (bottomSize * 0.5),
                  child: Text(
                    bookDetails.title,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 25),
                    textAlign: TextAlign.left,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  height: (bottomSize * 0.25),
                  alignment: Alignment.topCenter,
                  child: Text(
                    authorText,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontStyle: FontStyle.italic),
                    maxLines: 2,
                  ),
                ),
                Container(
                  height: (bottomSize * 0.25),
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: width / 2,
                        height: (bottomSize * 0.25),
                        color: Colors.black,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: (bottomSize * 0.25),
                        width: width / 2,
                        color: Colors.black,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            // TODO: change sizes

            width: width,
            height: bottomSize,
          ),
        ],
      ),
    );
  }

  Widget description() {
    return Container(
      child: Row(children: <Widget>[leftTile(), rightTile()]),
    );
  }

// TODO: change sizes
  Widget rightTile() {
    var width = MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width / 1.5;
    return Container(
      // TODO: change sizes

      width: width,
      height:
          (MediaQuery.of(context).size.height - appbar.preferredSize.height),
      color: Colors.black.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[GestureDetector(
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  boxShadow: [BoxShadow(blurRadius: 10)]),
              padding: EdgeInsets.all(10),
              // TODO: change sizes

              width: width,
              height: width,
              child: IconButton(
                icon: Icon(Icons.file_download),
                iconSize: 40,
              )),
        ),
          GestureDetector(
            onTap: () {
              print("describe");
              showDialog(context: context, builder: (_) => descriptionPopup());
            },
            child: Container(
              padding: EdgeInsets.all(10),
              // TODO: change sizes

              width: width,
              height: width,
//              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  boxShadow: [BoxShadow(blurRadius:10)]),
              child: IconButton(
                icon: Icon(Icons.description),
                iconSize: 40,
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              print("describe");
              showDialog(context: context, builder: (_) => descriptionPopup());
            },
            child: Container(
              padding: EdgeInsets.all(10),
              // TODO: change sizes

              width: width,
              height: width,
//              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.brown,
                  boxShadow: [BoxShadow(blurRadius:10)]),
              child: IconButton(
                icon: Icon(Icons.chrome_reader_mode),
                iconSize: 40,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print("describe");
              showDialog(context: context, builder: (_) => descriptionPopup());
            },
            child: Container(
              padding: EdgeInsets.all(10),
              // TODO: change sizes

              width: width,
              height: width,
//              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey,
                  boxShadow: [BoxShadow(blurRadius:10)]),
              child: IconButton(
                icon: Icon(Icons.delete),
                iconSize: 40,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget descriptionPopup() {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.2),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back)),
      body: Container(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Container(
              child: bookComments != null
                  ? Html(data: bookComments.text,
                      defaultTextStyle: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          color: Colors.white))
                  : Container(
                      alignment: Alignment.center,
                      child: Text(
                        'No description',
                        textAlign: TextAlign.start,
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

  var appbar = AppBar(
    backgroundColor: Colors.transparent,
    title: Text('Details'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar,
      body: FutureBuilder<void>(
          future: myFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return description();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

//FloatingActionButton(
