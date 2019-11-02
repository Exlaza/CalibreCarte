import 'dart:convert';

import 'package:calibre_carte/helpers/comments_provider.dart';
import 'package:calibre_carte/models/comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  Map<String, String> imageHttpHeaders;
  String dropboxDownloadUrl = "https://content.dropboxapi.com/2/files/download";

  Future<String> getTokenFromSharedPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('token') ?? "iWMa931y4c4AAAAAAAABG9VeRCMOkBy80ElDs2_2ETwTOf8zgbiIbP2LoZZCe9bY";
  }

  Future<String> getSelectedCalibreLibPath() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('selected_calibre_lib_path') ?? '/Calibre Library/';
  }

  buildImageHeaders(token, path) async {
    imageHttpHeaders = {
      "Authorization": "Bearer $token",
      "Dropbox-API-Arg": jsonEncode({"path": path})
    };
  }

  Future<void> getBookDetails() async {
    bookDetails = await BooksProvider.getBookByID(widget.bookId, null);
    bookComments =
        await CommentsProvider.getCommentByBookID(widget.bookId, null);

    String token = await getTokenFromSharedPreferences();
    String path = bookDetails.path;
    //This base path can actually cause problems for you because this would contain the metadata.db stuff. I don't want to store that
    String basePath = await getSelectedCalibreLibPath();
    String actualPath = basePath + path + '/cover.jpg';
    print(actualPath);

    await buildImageHeaders(token, actualPath);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = getBookDetails();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: myFuture, // a previously-obtained Future<String> or null
      builder:
          (BuildContext context, AsyncSnapshot<void> snapshot) {
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
                title: Text(bookDetails.title),
              ),
              body: Container(
                margin: EdgeInsets.all(20),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15)),
                          child: CachedNetworkImage(
                            imageUrl: dropboxDownloadUrl,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            httpHeaders: imageHttpHeaders,
                          ),
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
                                        Text('Title: ${bookDetails.title}'),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            'Author(s): ${bookDetails.author_sort}'),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('ISBN: ${bookDetails.isbn}')
                                      ],
                                    ),
                                    SingleChildScrollView(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          child: Html(
                                            data: bookComments.text,
                                          ),
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
