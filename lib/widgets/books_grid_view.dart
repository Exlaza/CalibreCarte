import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:calibre_carte/widgets/grid_tile.dart';
import 'package:flutter/material.dart';

class BooksGridView extends StatelessWidget {
  final String filter;
  final List<Books> books;
  final List<Map<String, String>> authorNames;

  BooksGridView(this.filter, this.books, this.authorNames);


  @override
  Widget build(BuildContext context) {
    print("rebuilding grid");


    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(0),
          sliver: SliverGrid.count(
            childAspectRatio: 2 / 3,
            crossAxisCount: 2,
            children: filter == null
                ? books.map((book) => CalibreGridTile(book)).toList()
                : books
                    .where((book) =>
                        book.title.toLowerCase().contains(filter.toLowerCase()))
                    .toList()
                    .map((book) => CalibreGridTile(book)).toList(),
          ),
        )
      ],
    );
  }
}
