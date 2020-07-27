import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/providers/book_details_navigation_provider.dart';
import 'package:calibre_carte/providers/list_tile.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:calibre_carte/widgets/download_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalibreGridTile extends StatefulWidget {
  final int index;
  final Books book;
  final List<Books> books;
  CalibreGridTile(this.index, this.book, this.books);

  @override
  _CalibreGridTileState createState() => _CalibreGridTileState();
}

class _CalibreGridTileState extends State<CalibreGridTile> {
  bool refresh=false;

  void refreshTile() {
    setState(() {
      refresh = false;
    });
  }

  void viewBookDetails(int bookId, BuildContext context) {
//    print(bookId);
    BookDetailsNavigation bn =
        Provider.of<BookDetailsNavigation>(context, listen: false);
    bn.bookID = bookId;
    bn.booksList = widget.books;
    bn.index = widget.index;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Consumer<BookDetailsNavigation>(
        builder: (ctx, bookNav, child) => BookDetailsScreen(
          bookId: bookNav.bookID != null ? bookNav.bookID : bookId,refreshTile: refreshTile,
        ),
      );
    })).then((_) {
      bn.bookID = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ListTileProvider lstp = Provider.of(context, listen: false);
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
              key: Key(widget.book.path),
              child: BookDetailsCoverImage(widget.book.id, widget.book.path, null, null)),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => viewBookDetails(widget.book.id, context),
              child: Container(),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
//                border: Border.all(),
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.black.withOpacity(0.6),
                ),
                alignment: Alignment.centerLeft,
                height: MediaQuery.of(context).size.height / 15,
//              width: MediaQuery.of(context).size.width / 2.4,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      padding: EdgeInsets.only(left: 3),
                      child: Text(
                        widget.book.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                    ),
                    Consumer<ListTileProvider>(builder: (ctx, lstp, child) {
                      return DownloadIcon(
                        widget.books[widget.index].id,
                      );
                    }),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
