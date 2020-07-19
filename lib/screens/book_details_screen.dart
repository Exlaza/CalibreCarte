import 'package:calibre_carte/helpers/authors_provider.dart';
import 'package:calibre_carte/helpers/book_author_link_provider.dart';
import 'package:calibre_carte/helpers/book_downloader.dart';
import 'package:calibre_carte/helpers/book_publisher_link_provider.dart';
import 'package:calibre_carte/helpers/book_rating_link_provider.dart';
import 'package:calibre_carte/helpers/comments_provider.dart';
import 'package:calibre_carte/helpers/data_provider.dart';
import 'package:calibre_carte/helpers/publishers_provider.dart';
import 'package:calibre_carte/helpers/ratings_provider.dart';
import 'package:calibre_carte/models/authors.dart';
import 'package:calibre_carte/models/books_authors_link.dart';
import 'package:calibre_carte/models/books_ratings_link.dart';
import 'package:calibre_carte/models/comments.dart';
import 'package:calibre_carte/models/data.dart';
import 'package:calibre_carte/models/publishers.dart';
import 'package:calibre_carte/models/ratings.dart';
import 'package:calibre_carte/widgets/details_screen_widgets/details_lefttile.dart';
import 'package:calibre_carte/widgets/details_screen_widgets/details_sidebar.dart';
import 'package:flutter/material.dart';
import '../helpers/books_provider.dart';
import '../models/books.dart';

class BookDetailsScreen extends StatefulWidget {
  static const routeName = '/book-detailsbeta';
  final int bookId;
  final Function refreshTile;
  BookDetailsScreen({this.bookId, this.refreshTile});

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  Books bookDetails;
  Ratings rating;
  BooksRatingLink ratingLink;
  Comments bookComments;
  Future myFuture;
  String localImagePath;
  String authorText;
  Future mySecondFuture;
  List<Map<String, String>> dataFormatsFileNameMap = List();
  Publishers publishers;

  Future<bool> checkIfLocalCopyExists() async {
//    print(authorText);
    List<Data> dataList = await DataProvider.getDataByBookID(widget.bookId);
    List<Map<String, String>> dataFormatsFileNameMapTemp = List();

    dataList.forEach((element) {
//      print(element.name);
      String fileNameWithExtension =
          element.name + '.' + element.format.toLowerCase();
      Map<String, String> tempMap = {
        "format": element.format,
        "name": fileNameWithExtension
      };
      dataFormatsFileNameMapTemp.add(tempMap);
    });
    BookDownloader bd = BookDownloader();

    for (int i = 0; i < dataFormatsFileNameMapTemp.length; i++) {
//      print(dataFormatsFileNameMapTemp[i]['name']);
      bool exists = await bd
          .checkIfDownloadedFileExists(dataFormatsFileNameMapTemp[i]['name']);
      if (exists) {
        dataFormatsFileNameMap = dataFormatsFileNameMapTemp;
        return true;
      }
    }
    dataFormatsFileNameMap = dataFormatsFileNameMapTemp;
    return false;
  }

  _checkCopies() {
    setState(() {
      mySecondFuture = checkIfLocalCopyExists();
    });
    widget.refreshTile();
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
    rating = await BooksRatingLinkProvider.getRatingByBookID(widget.bookId);
    publishers =
        await BooksPublisherLinkProvider.getPublisherByBookID(widget.bookId);
  }

  @override
  void initState() {
    super.initState();
    myFuture = getBookDetails();
    mySecondFuture = checkIfLocalCopyExists();
  }

  @override
  void didUpdateWidget(BookDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bookId == widget.bookId) {
      return;
    }

    myFuture = getBookDetails().then((_) {
      mySecondFuture = checkIfLocalCopyExists();
    });
//    mySecondFuture = checkIfLocalCopyExists();
  }
  textScaleFactor(BuildContext context) {
    if (MediaQuery.of(context).size.height > 610) {
      return MediaQuery.of(context).textScaleFactor.clamp(0.6, 1.0);
    } else {
      return MediaQuery.of(context).textScaleFactor.clamp(0.6, 0.85);
    }
  }
  Widget description() {
    var totalHeight = MediaQuery.of(context).size.height -
        appbar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              textScaleFactor(context)),
      child: Container(
        child: Row(children: <Widget>[
          DetailsLeftTile(
            publishers: publishers,
//          rating: Ratings.fromMapObject({'id':1,'rating':3}),
            rating: rating,
            bookId: widget.bookId,
            bookDetails: bookDetails,
            authorText: authorText,
            totalHeight: totalHeight,
          ),
          rightTile()
        ]),
      ),
    );
  } // TODO: change sizes

  Widget rightTile() {
    var totalHeight = MediaQuery.of(context).size.height -
        appbar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
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
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text(
        'Details',
        style: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.white,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context).copyWith(
        textScaleFactor:
        textScaleFactor(context)),
      child: Scaffold(
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
      ),
    );
  }
}

//FloatingActionButton(
