import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/widgets/grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BooksGridView extends StatelessWidget {
  final String filter;
  final List<Books> books;

  BooksGridView(this.filter, this.books);

  Widget scrollGrid(List<Widget> children, BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(0),
          sliver: SliverGrid.count(
            childAspectRatio: 2 / 3,
            crossAxisCount: 2,
//            mainAxisSpacing: 5.0,
            children: children,
          ),
        )
      ],
    );
  }

  List<Books> filterBooks(List<Books> books, String searchFilter, String searchKey) {
    List<Books> filteredBooks;

    if (searchFilter == 'title') {
      filteredBooks = books
          .where((book) =>
              book.title.toLowerCase().contains(searchKey.toLowerCase()))
          .toList();
    } else if (searchFilter == 'author') {
      filteredBooks = books
          .where((book) =>
              book.author_sort.toLowerCase().contains(searchKey.toLowerCase()))
          .toList();
    } else {
      filteredBooks = books;
    }

    return filteredBooks;
  }

  @override
  Widget build(BuildContext context) {
    Update update = Provider.of(context);
    List<Books> filteredBooks = filterBooks(books, update.searchFilter, filter);

    return scrollGrid(
        filteredBooks
            .asMap()
            .map((index, book) =>
                MapEntry(index, CalibreGridTile(index, book, books)))
            .values
            .toList(),
        context);
  }
}
