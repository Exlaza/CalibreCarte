import 'package:calibre_carte/helpers/book_author_link_provider.dart';
import 'package:calibre_carte/models/books_authors_link.dart';
import 'package:calibre_carte/widgets/books_carousel_view.dart';
import 'package:calibre_carte/widgets/books_grid_view.dart';
import 'package:calibre_carte/widgets/books_list_view.dart';
import 'package:flutter/material.dart';
import 'package:calibre_carte/helpers/authors_provider.dart';
import 'package:calibre_carte/helpers/books_provider.dart';
import 'package:calibre_carte/models/authors.dart';
import 'package:calibre_carte/models/books.dart';

class BooksView extends StatefulWidget {
  final String layout;
  final String filter;

  BooksView(this.layout, this.filter);

  @override
  _BooksViewState createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
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
                    ? BooksListView(widget.filter, books, authorNames)
                    : (widget.layout == "grid"
                        ? BooksGridView(widget.filter, books, authorNames)
                        : BooksCarouselView(widget.filter, books, authorNames));
          }
        });
  }
}
