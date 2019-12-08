import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:calibre_carte/widgets/grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BooksGridView extends StatelessWidget {
  final String filter;
  final List<Books> books;

  BooksGridView(this.filter, this.books);

  Widget scrollGrid(List<Widget>children, BuildContext context){
   return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(0),
          sliver: SliverGrid.count(
            childAspectRatio: 2/3,
            crossAxisCount: 2,
//            mainAxisSpacing: 5.0,
            children: children,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
//    print("rebuilding grid");

    Update update = Provider.of(context);
    return update.searchFilter == 'title'
        ? scrollGrid(filter == null
        ? books.map((book) => CalibreGridTile(book)).toList()
        : books
        .where((book) => book.title
        .toLowerCase()
        .contains(filter.toLowerCase()))
        .toList()
        .map((book) => CalibreGridTile(book))
        .toList(), context)
        : scrollGrid(filter == null
        ? books.map((book) => CalibreGridTile(book)).toList()
        : books
        .where((book) => book.author_sort
        .toLowerCase()
        .contains(filter.toLowerCase()))
        .toList()
        .map((book) => CalibreGridTile(book))
        .toList(), context);
  }
}
