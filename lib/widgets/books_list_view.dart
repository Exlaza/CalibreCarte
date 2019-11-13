import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:calibre_carte/widgets/download_icon.dart';
import 'package:flutter/material.dart';

class BooksListView extends StatelessWidget {
  final String filter;
  final List<Books> books;
  final List<Map<String, String>> authorNames;

  BooksListView(this.filter, this.books, this.authorNames);

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

    Widget tile(int index) {
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
              child: BookDetailsCoverImage(books[index].id, books[index].path)),
          subtitle: Text(
            authorNames.firstWhere((auth) =>
                auth["book"] == books[index].id.toString())["authors"],
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return ListView.builder(
      itemBuilder: (ctx, index) {
        return filter == null
            ? tile(index)
            : (books[index].title.toLowerCase().contains(filter.toLowerCase())
                ? tile(index)
                : Container());
      },
      itemCount: books.length,
    );
  }
}
