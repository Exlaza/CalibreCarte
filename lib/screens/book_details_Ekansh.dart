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
import 'package:calibre_carte/widgets/details_lefttile.dart';
import 'package:calibre_carte/widgets/details_sidebar.dart';
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

  _checkCopies() {
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

  Widget description() {
    var totalHeight = MediaQuery.of(context).size.height -
        appbar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Container(
      child: Row(children: <Widget>[
        DetailsLeftTile(
          bookId: widget.bookId,
          bookDetails: bookDetails,
          authorText: authorText,
          totalHeight: totalHeight,
        ),
        rightTile()
      ]),
    );
  }

// TODO: change sizes
  Widget rightTile() {
    var width = MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width / 1.5;
    var totalHeight = MediaQuery.of(context).size.height -
        appbar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    var color = Color(0xffFED962);
    var altColor = Color(0xffFFE06F);
    var activeIcon = Colors.black;
    var inactiveIcon = Colors.grey;
    return FutureBuilder(
      future: mySecondFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data) {
            return DetailsSidebar(
              bookComments: bookComments,
              bookDetails: bookDetails,
              bookId: widget.bookId,
              dataFormatsFileNameMap: dataFormatsFileNameMap,
              downloaded: snapshot.data,
              totalHeight: totalHeight,
              checkCopies: _checkCopies,
            );
          } else {
            return DetailsSidebar(
                bookComments: bookComments,
                bookDetails: bookDetails,
                bookId: widget.bookId,
                dataFormatsFileNameMap: dataFormatsFileNameMap,
                downloaded: snapshot.data,
                totalHeight: totalHeight,
                checkCopies: _checkCopies);
          }
        } else {
          return DetailsSidebar(
              bookComments: bookComments,
              bookDetails: bookDetails,
              bookId: widget.bookId,
              dataFormatsFileNameMap: dataFormatsFileNameMap,
              downloaded: false,
              totalHeight: totalHeight,
              checkCopies: _checkCopies);
        }
      },
    );
  }

  var appbar = AppBar(
      backgroundColor: Color(0xff002242),
      title: Text(
        'Details',
        style: TextStyle(
          fontFamily: 'Montserrat',
          color: Color(0xffFED962),
        ),
      ));

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
