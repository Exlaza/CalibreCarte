import 'package:calibre_carte/helpers/book_author_link_provider.dart';
import 'package:calibre_carte/models/books_authors_link.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:calibre_carte/widgets/download_icon.dart';
import 'package:calibre_carte/widgets/get_book_thumbnail.dart';
import 'package:flutter/material.dart';

import 'package:calibre_carte/helpers/authors_provider.dart';
import 'package:calibre_carte/helpers/books_provider.dart';
import 'package:calibre_carte/helpers/tags_provider.dart';
import 'package:calibre_carte/models/authors.dart';
import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/models/tags.dart';

import '../screens/book_details_screen.dart';

class BooksList extends StatefulWidget {
  final String layout;

  BooksList(this.layout);

  @override
  _BooksListState createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  Future bookDetails;
  List<Books> books;
  List<Map<String, String>> authorNames = [];

  //get all details for once
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookDetails = getBooks();
  }

  //send book details to next screen
  void viewBookDetails(int bookId) {
    print(bookId);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return BookDetailsScreen(
        bookId: bookId,
      );
    }));
  }

  //aggregates all the data to display
  Future<void> getBooks() async {
    String authorText;
    books = await BooksProvider.getAllBooks();
    print("got books");
    for (int i = 0; i < books.length; i++) {
      List<BooksAuthorsLink> bookAuthorsLinks =
          await BooksAuthorsLinksProvider.getAuthorsByBookID(books[i].id);
      List<String> authors = List();
      for (int i = 0; i < bookAuthorsLinks.length; i++) {
        int authorID = bookAuthorsLinks[i].author;
        Authors author = await AuthorsProvider.getAuthorByID(authorID, null);
        authors.add(author.name);

        print("got authors");

        authorText = authors.reduce((v, e) {
          return v + ', ' + e;
        });
      }
      authorNames.add({"book": books[i].id.toString(), "authors": authorText});
    }
    print(authorNames[1]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: bookDetails,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return widget.layout == "list"
                    ? booksListView(context, snapshot)
                    : booksGridView(context, snapshot);
          }
        });
  }

  Widget booksListView(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Card(
          color: Colors.grey.withOpacity(0.5),
          elevation: 8,
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(5),
            onTap: () => viewBookDetails(books[index].id),

            trailing: DownloadIcon(),
//title: Text(books[index]['title'],style:TextStyle(fontWeight: FontWeight.bold)),
            title: Container(
                height: 40,
                width: 240,
                child: Text(
                  books[index].title,
                  overflow: TextOverflow.ellipsis,
                )),
            leading: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 100, maxWidth: 50),
                child: GetBookThumbnail(books[index].id, books[index].path)),
            subtitle: Text(
              authorNames.firstWhere((auth) =>
                  auth["book"] == books[index].id.toString())["authors"],
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
      itemCount: books.length,
    );
  }

  Widget booksGridView(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
//      padding: EdgeInsets.all(10),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: (MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height*0.9 ))),
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () => viewBookDetails(books[index].id),
          child: Card(
              color: Colors.brown.withOpacity(0.1),
              margin: const EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 5,
              ),
              elevation: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: GetBookThumbnail(books[index].id,books[index].path),
                  ),
//                  Container(
//                      color: Colors.brown.withOpacity(0.4),
//                      child: Text(books[index].title,
//                          style: TextStyle(fontWeight: FontWeight.bold))),
//                  Container(
//                    color: Colors.grey.withOpacity(0.8),
//                    child: Text(
//                      authorNames.firstWhere((auth) =>
//                      auth["book"] == books[index].id.toString())["authors"],
//                      style: TextStyle(fontWeight: FontWeight.bold),
//                      overflow: TextOverflow.ellipsis,
//                    ),
//                  ),
                ],
              )),
        );
      },
      itemCount: books.length,
    );
  }
}
