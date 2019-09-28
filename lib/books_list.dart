import 'package:calibre_carte/helpers/authors_provider.dart';
import 'package:calibre_carte/helpers/books_provider.dart';
import 'package:calibre_carte/helpers/tags_provider.dart' ;
import 'package:calibre_carte/models/authors.dart';
import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/models/tags.dart';
import 'package:flutter/material.dart';

class BooksList extends StatefulWidget {
  @override
  _BooksListState createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getBooks(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Text('Loading...',style: TextStyle(fontSize: 20),);
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return booksListView(context, snapshot);
          }
        });
  }

  //aggregates all the data to display
  Future getBooks() async {
    var books = await BooksProvider.getAllBooks();
    var authors = await AuthorsProvider.getAllAuthors();
    var tags= await TagsProvider.getAllTags();
    return {'books': books, 'authors': authors, 'tags': tags};
  }


  Widget booksListView(BuildContext context, AsyncSnapshot snapshot) {
    Map bookMap = snapshot.data;
    List<Authors> authors = bookMap['authors'];
    List<Books> books = bookMap['books'];
    List<Tags> tags=bookMap['tags'];
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
              //title: Text(books[index]['title'],style:TextStyle(fontWeight: FontWeight.bold)),
              title: Text(books[index].title),
              leading: CircleAvatar(
                radius: 50,
                child: ClipOval(
                    child: Image.asset(
                  'assets/images/calibre_logo.png',
                  fit: BoxFit.scaleDown,
                )),
              ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(authors[index].name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(tags[index].name)
                  ]),
            ),
          ),
        );
      },
      itemCount: books.length,
    );
  }


}
