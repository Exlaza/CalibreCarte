import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/providers/book_details_navigation_provider.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/widgets/cool_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BooksListView extends StatelessWidget {
  final String filter;
  final List<Books> books;

  BooksListView(this.filter, this.books);

  @override
  Widget build(BuildContext context) {
//    TODO: Can definitely improve this piece of code
    Update update = Provider.of(context);
    return update.searchFilter == 'title'
        ? ListView.builder(
            itemBuilder: (ctx, index) {
              return filter == null
                  ? CoolTile(index, books)
                  : (books[index]
                          .title
                          .toLowerCase()
                          .contains(filter.toLowerCase())
                      ? CoolTile(index, books)
                      : Container());
            },
            itemCount: books.length,
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return filter == null
                  ? CoolTile(index, books)
                  : (books[index]
                          .author_sort
                          .toLowerCase()
                          .contains(filter.toLowerCase())
                      ? CoolTile(index, books)
                      : Container());
            },
            itemCount: books.length,
          );
  }
}
