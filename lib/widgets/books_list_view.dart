import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:calibre_carte/widgets/download_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BooksListView extends StatelessWidget {
  final String filter;
  final List<Books> books;

  BooksListView(this.filter, this.books);

  @override
  Widget build(BuildContext context) {
    Update update = Provider.of(context);

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
          trailing: DownloadIcon(books[index].id),
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
            books[index].author_sort,
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return update.searchFilter=='title'?ListView.builder(
      itemBuilder: (ctx, index) {
        return filter == null
            ? tile(index)
            : (books[index].title.toLowerCase().contains(filter.toLowerCase())
                ? tile(index)
                : Container());
      },
      itemCount: books.length,
    ):ListView.builder(
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
