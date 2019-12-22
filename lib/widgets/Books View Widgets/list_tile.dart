import 'package:calibre_carte/helpers/text_style.dart';
import 'package:calibre_carte/providers/book_details_navigation_provider.dart';
import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:calibre_carte/widgets/download_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoolTile extends StatelessWidget {
  final index;
  final books;

  CoolTile(this.index, this.books);

  void viewBookDetails(int bookId, BuildContext context) {
//      print(bookId);
    BookDetailsNavigation bn =
        Provider.of<BookDetailsNavigation>(context, listen: false);
    bn.bookID = bookId;
    bn.booksList = books;
    bn.index = index;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Consumer<BookDetailsNavigation>(
        builder: (ctx, bookNav, child) => BookDetailsScreen(
          bookId: bookNav.bookID != null ? bookNav.bookID : bookId,
        ),
      );
    })).then((_) {
      bn.bookID = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorTheme colorTheme=Provider.of(context);
    return GestureDetector(
      onTap: () => viewBookDetails(books[index].id, context),
      child: Container(
        height: MediaQuery.of(context).size.height / 5,
        decoration: new BoxDecoration(
          color: index % 2 == 0 ? colorTheme.tileColor1 : colorTheme.tileColor2,
          shape: BoxShape.rectangle,
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: new Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              child: Container( color: Colors.white,
                child: BookDetailsCoverImage(
                    books[index].id,
                    books[index].path,
                    MediaQuery.of(context).size.height / 5,
                    MediaQuery.of(context).size.width / 3.7),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 16,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(height: 15.0),
                  Text(
                    books[index].title,
                    style: TextStyling.headerTextStyle.copyWith(color: colorTheme.headerText),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Container(height: 10.0),
                  Text(
                    books[index].author_sort,
                    style: TextStyling.subHeaderTextStyle.copyWith(color: colorTheme.subHeaderText),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        height: 2.0,
                        width: 18.0,
                        color: Color(0xff00c6ff),
                      ),Container(height: 2,),DownloadIcon(books[index].id)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
