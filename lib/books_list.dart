import 'package:calibre_carte/helpers/book_author_link_provider.dart';
import 'package:calibre_carte/models/books_authors_link.dart';
import 'package:flutter/material.dart';

import 'package:calibre_carte/helpers/authors_provider.dart';
import 'package:calibre_carte/helpers/books_provider.dart';
import 'package:calibre_carte/helpers/tags_provider.dart';
import 'package:calibre_carte/models/authors.dart';
import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/models/tags.dart';

import './screens/book_details_screen.dart';

class BooksList extends StatefulWidget {
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
                return booksListView(context, snapshot);
          }
        });
  }

  Widget booksListView(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Card(
          elevation: 10,
          margin: const EdgeInsets.symmetric(
            vertical: 7,
            horizontal: 5,
          ),
          child: Container(
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.blueGrey, Colors.grey])),
            child: ListTile(
              onTap: () => viewBookDetails(books[index].id),
              title: Text(books[index].title,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              leading: CircleAvatar(
                radius: 50,
                child: ClipOval(
                    child: Image.asset(
                  'assets/images/cover.jpg',
                  fit: BoxFit.scaleDown,
                )),
              ),
              subtitle: Text(
                authorNames.firstWhere((auth) =>
                    auth["book"] == books[index].id.toString())["authors"],
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
      itemCount: books.length,
    );
  }
}
