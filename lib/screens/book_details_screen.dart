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

class BookDetailsScreen extends StatefulWidget {
  static const routeName = '/book-details';
  final int bookId;

  BookDetailsScreen({this.bookId});

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
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
    // TODO: implement initState
    super.initState();
    myFuture = getBookDetails();
    mySecondFuture = checkIfLocalCopyExists();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/images/subtle_wood.png',
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black.withOpacity(0.5),
            title: Text('Book Info'),
          ),
          floatingActionButton: FutureBuilder(
              future: mySecondFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: FloatingActionButton(
                              heroTag: "2",
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => OpenFormatDialog(
                                        widget.bookId, bookDetails.path));
                              },
                              child: Icon(Icons.library_books)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(
                                height: 40,
                                width: 40,
                                child: FloatingActionButton(
                                  onPressed: () async {
                                    deleteAllLocalCopies();
                                  },
                                  heroTag: "1",
                                  child: Icon(
                                    Icons.delete,
                                  ),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            FloatingActionButton(
                              heroTag: "0",
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => SelectFormatDialog(
                                        widget.bookId, bookDetails.path));
                              },
                              child: Icon(Icons.file_download),
                            )
                          ],
                        )
                      ],
                    );
                  } else {
                    return FloatingActionButton(
                      child: Icon(Icons.file_download),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => SelectFormatDialog(
                                widget.bookId, bookDetails.path)).then((_) {
                          setState(() {
                            mySecondFuture = checkIfLocalCopyExists();
                          });
                        });
                      },
                    );
                  }
                } else {
                  return FloatingActionButton(
                    child: Icon(Icons.file_download),
                  );
                }
              }),
          body: FutureBuilder<void>(
              future: myFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),bottom: Radius.circular(15)
                            ),
                            child: BookDetailsCoverImage(
                                widget.bookId, bookDetails.path),
                          ),
                        ),
                        DefaultTabController(
                            // The number of tabs / content sections to display.
                            length: 2,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: TabBar(
                                    unselectedLabelColor: Colors.black,
                                    labelColor: Colors.black,
                                    tabs: [
                                      Tab(
                                        icon: Icon(Icons.import_contacts),
                                        text: 'MetaData',
                                      ),
                                      Tab(
                                        icon: Icon(Icons.description),
                                        text: 'Description',
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 250,
                                  child: TabBarView(
                                    children: [
                                      Column(
                                        children: <Widget>[
                                          Text('Title: ${bookDetails.title}'),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('Author(s): $authorText'),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('ISBN: ${bookDetails.isbn}')
                                        ],
                                      ),
                                      SingleChildScrollView(
                                          padding: EdgeInsets.all(10),
                                          child: Container(
                                            child: bookComments != null
                                                ? Html(
                                                    data: bookComments.text,
                                                  )
                                                : Center(
                                                    child: Text(
                                                      'No description',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        )
      ],
    );
  }
}

//FloatingActionButton(
