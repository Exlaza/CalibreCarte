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

//    Widget tile(int index) {
//      return Card(
//        color: Colors.grey.withOpacity(0.5),
//        elevation: 8,
//        margin: const EdgeInsets.symmetric(
//          vertical: 10,
//          horizontal: 10,
//        ),
//        child: ListTile(
//          contentPadding: EdgeInsets.all(5),
//          onTap: () => viewBookDetails(books[index].id),
//          trailing: DownloadIcon(),
////title: Text(books[index]['title'],style:TextStyle(fontWeight: FontWeight.bold)),
//          title: Container(
//              height: 40,
//              width: 240,
//              child: Text(
//                books[index].title,
//                overflow: TextOverflow.ellipsis,
//              )),
//          leading: ConstrainedBox(
//              constraints: BoxConstraints(maxHeight: 100, maxWidth: 50),
//              child: BookDetailsCoverImage(books[index].id, books[index].path)),
//          subtitle: Text(
//            books[index].author_sort,
//            style: TextStyle(fontWeight: FontWeight.bold),
//            overflow: TextOverflow.ellipsis,
//          ),
//        ),
//      );
//    }

//    This card is a blatant ripoff from the godlevel link
//    https://sergiandreplace.com/planets-flutter-adding-content-to-the-card/
//    Apna author, title overflow kar rha, toh usko ... karna padega

    final baseTextStyle = const TextStyle(
        fontFamily: 'Poppins'
    );
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 9.0,
        fontWeight: FontWeight.w400
    );
    final subHeaderTextStyle = regularTextStyle.copyWith(
        fontSize: 12.0
    );
    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w600
    );

    Widget _planetValue({String value, String image}) {
      return Row(
          children: <Widget>[
            Icon(Icons.keyboard_arrow_down),
            Container(width: 8.0),
            Text("10", style: regularTextStyle),
          ]
      );
    }

    Widget tile(index) {
      return Container(
        height: 120,
        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Stack(
          children: <Widget>[
            Container(
              child: Container(
                margin: EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
                constraints: BoxConstraints.expand(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 4.0),
                    Text(books[index].title, style: headerTextStyle),
                    Container(height: 10.0),
                    Text(books[index].author_sort, style: subHeaderTextStyle),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        height: 2.0,
                        width: 18.0,
                        color: Color(0xff00c6ff)
                    ),
                  ],
                ),
              ),
              height: 124.0,
              margin: new EdgeInsets.only(left: 46.0),
              decoration: new BoxDecoration(
                color: new Color(0xFF333366),
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.circular(8.0),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: new Offset(0.0, 10.0),
                  ),
                ],
              ),
            ),
            Container(
              margin: new EdgeInsets.symmetric(vertical: 16.0),
              alignment: FractionalOffset.centerLeft,
              child: BookDetailsCoverImage(books[index].id, books[index].path),
            ),
          ],
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
