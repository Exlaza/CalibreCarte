import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:flutter/material.dart';

class CalibreGridTile extends StatelessWidget {
  final Books book;

  CalibreGridTile(this.book);

  @override
  Widget build(BuildContext context) {
    void viewBookDetails(int bookId) {
//      print(bookId);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return BookDetailsScreen(
          bookId: bookId,
        );
      }));
    }

    return GestureDetector(
      onTap: () => viewBookDetails(book.id),
      child: Card(
          color: Colors.transparent,
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
                child: Container(
                    key: Key(book.title),
                    child: BookDetailsCoverImage(book.id, book.path) ??
                        Text("no image")),
              ),
            ],
          )),
    );
  }
}
