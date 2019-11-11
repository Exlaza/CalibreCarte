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
  final String sortOption;
  final String sortDirection;

  BooksView(this.layout, this.filter, {this.sortOption, this.sortDirection });

  @override
  _BooksViewState createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  Future bookDetails;
  List<Books> books;
  List<Map<String, String>> authorNames = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookDetails = getBooks();
  }

  @override
  void didUpdateWidget(BooksView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("COming her eafter sort");
    if (oldWidget.sortOption == widget.sortOption && oldWidget.sortDirection == widget.sortDirection){
      return;
    }
    bookDetails = getBooks();
  }

  void sortBooks() {
    if (widget.sortOption == 'author') {
        books.sort((a, b) {
          return a.author_sort.compareTo(b.author_sort);
      });

    } else if (widget.sortOption == 'title') {
        books.sort((a, b) {
          return a.title.compareTo(b.title);
      });
    } else {
        books.sort((a, b) {
          return a.title.compareTo(b.title);
      });
    }

    if (widget.sortDirection == 'desc'){
      print("descending of something in here");
        books = books.reversed.toList();
    }

  }

  //aggregates all the data to display
  Future<void> getBooks() async {

    print("NOt even coming here");
    String authorText;
    books = await BooksProvider.getAllBooks();
    for (int i = 0; i < books.length; i++) {
      List<BooksAuthorsLink> bookAuthorsLinks =
          await BooksAuthorsLinksProvider.getAuthorsByBookID(books[i].id);
      List<String> authors = List();
      for (int i = 0; i < bookAuthorsLinks.length; i++) {
        int authorID = bookAuthorsLinks[i].author;
        Authors author = await AuthorsProvider.getAuthorByID(authorID, null);
        authors.add(author.name);

        authorText = authors.reduce((v, e) {
          return v + ', ' + e;
        });
      }
      authorNames.add({"book": books[i].id.toString(), "authors": authorText});
      books[i].author_sort = authorText;
    }

    sortBooks();

    print(authorNames[1]);
  }

  @override
  Widget build(BuildContext context) {
    print("rebuilding books");
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
