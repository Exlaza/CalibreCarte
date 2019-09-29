import 'package:calibre_carte/helpers/comments_provider.dart';
import 'package:calibre_carte/models/authors.dart';
import 'package:calibre_carte/models/comments.dart';
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
  Future<Map<String, Object>> getBookDetails() async {
    Books bookDetails = await BooksProvider.getBookByID(widget.bookId, null);
    Comments bookComments =
        await CommentsProvider.getCommentByBookID(widget.bookId, null);

    return {'bookDetails': bookDetails, 'bookComments': bookComments};
  }

  @override
  Widget build(BuildContext context) {
    print("called build for Book details screen");
    return FutureBuilder<Map<String, Object>>(
      future: getBookDetails(), // a previously-obtained Future<String> or null
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, Object>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print("hello");
            return Text('Press button to start.');
          case ConnectionState.active:
            return Text('Something');
          case ConnectionState.waiting:
            return Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return Scaffold(
              appBar: AppBar(
                title: Text((snapshot.data['bookDetails'] as Books).title),
              ),
              body: Container(
                margin: EdgeInsets.all(20),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                            'https://nearst-product-images.s3-eu-west-1.amazonaws.com/f6128169-c96b-4071-a349-9029bf6963f0.jpg'),
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
                                      icon: Icon(Icons.directions_car),
                                      text: 'Meta',
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
                                        Text(
                                            'Title: ${(snapshot.data['bookDetails'] as Books).title}'),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            'Author(s): ${(snapshot.data['bookDetails'] as Books).author_sort}'),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            'ISBN: ${(snapshot.data['bookDetails'] as Books).isbn}')
                                      ],
                                    ),
                                    SingleChildScrollView(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          child: Html(
                                              data:
                                                  (snapshot.data['bookComments']
                                                          as Comments)
                                                      .text),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            );
        }
        return null; // unreachable
      },
    );
  }
}
