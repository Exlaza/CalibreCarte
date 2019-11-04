import 'dart:io';

import 'package:calibre_carte/helpers/authors_provider.dart';
import 'package:calibre_carte/helpers/book_author_link_provider.dart';
import 'package:calibre_carte/helpers/comments_provider.dart';
import 'package:calibre_carte/models/authors.dart';
import 'package:calibre_carte/models/books_authors_link.dart';
import 'package:calibre_carte/models/comments.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
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

  Future<void> getBookDetails() async {
    bookDetails = await BooksProvider.getBookByID(widget.bookId, null);
    print('Book details worjing fine');
    print(widget.bookId);
    bookComments =
        await CommentsProvider.getCommentByBookID(widget.bookId, null);
    print('book comments not working fine');
    List<BooksAuthorsLink> bookAuthorsLinks =
        await BooksAuthorsLinksProvider.getAuthorsByBookID(widget.bookId);

    List<String> authors = List();
    for (int i = 0; i < bookAuthorsLinks.length; i++) {
      int authorID = bookAuthorsLinks[i].author;
      Authors author = await AuthorsProvider.getAuthorByID(authorID, null);
      authors.add(author.name);
    }
    print("Wven coming here");

    authorText = authors.reduce((v, e) {
      return v + ', ' + e;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = getBookDetails();
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
                                top: Radius.circular(15),
                                bottom: Radius.circular(15)),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Title: ${bookDetails.title}',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text('Author(s): $authorText',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontStyle: FontStyle.italic)),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text('ISBN: ${bookDetails.isbn}',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontStyle: FontStyle.italic))
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
