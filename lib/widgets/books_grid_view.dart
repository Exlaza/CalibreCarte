import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:flutter/material.dart';

class BooksGridView extends StatelessWidget {
  final String filter;
  final List<Books> books;
  final List<Map<String, String>> authorNames;

  BooksGridView(this.filter, this.books, this.authorNames);

  @override
  Widget build(BuildContext context) {
    void viewBookDetails(int bookId) {
      print(bookId);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return BookDetailsScreen(
          bookId: bookId,
        );
      }));
    }

    return GridView.builder(
//      padding: EdgeInsets.all(10),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: (MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height * 0.83))),
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () => viewBookDetails(books[index].id),
          child: Card(
              color: Colors.transparent
              ,
              margin: const EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 5,
              ),
              elevation: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 3,
                    child: BookDetailsCoverImage(
                        books[index].id, books[index].path),
                  ),
//                  Container(
//                    height: 35,
//                      color: Colors.brown.withOpacity(0.4),
//                      child: Text(books[index].title,
//                          style: TextStyle(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)),
////                  Container(
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
