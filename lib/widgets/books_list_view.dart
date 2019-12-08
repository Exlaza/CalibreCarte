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
//      print(bookId);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return BookDetailsScreen(
          bookId: bookId,
        );
      }));
    }

    final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 9.0,
        fontWeight: FontWeight.w400);
    final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 12.0, fontFamily: 'Montserrat');
    final headerTextStyle = baseTextStyle.copyWith(fontFamily: 'Montserrat',
        color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600);

    Widget _planetValue({String value, String image}) {
      return Row(children: <Widget>[
        Icon(Icons.keyboard_arrow_down),
        Container(width: 8.0),
        Text("10", style: regularTextStyle),
      ]);
    }

//    Widget tile(index) {
//      return Container(
//        height: MediaQuery.of(context).size.height / 5,
//        child: Stack(
//          children: <Widget>[
//            Container(
//              child: Container(
//                margin: EdgeInsets.fromLTRB(40.0, 16.0, 10.0, 16.0),
//                constraints: BoxConstraints.expand(),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Container(height: 4.0),
//                    Text(
//                      books[index].title,
//                      style: headerTextStyle,
//                      overflow: TextOverflow.ellipsis,
//                      maxLines: 2,
//                    ),
//                    Container(height: 10.0),
//                    Text(
//                      books[index].author_sort,
//                      style: subHeaderTextStyle,
//                      overflow: TextOverflow.ellipsis,
//                    ),
//                    Container(
//                        margin: EdgeInsets.symmetric(vertical: 8.0),
//                        height: 2.0,
//                        width: 18.0,
//                        color: Color(0xff00c6ff)),
//                  ],
//                ),
//              ),
//              height: 124.0,
//              margin: new EdgeInsets.only(left: 46.0),
//              decoration: new BoxDecoration(
//                color: Colors.white,
//                shape: BoxShape.rectangle,
//                borderRadius: new BorderRadius.circular(8.0),
//                boxShadow: <BoxShadow>[
//                  new BoxShadow(
//                    color: Colors.black12,
//                    blurRadius: 10.0,
//                    offset: new Offset(0.0, 10.0),
//                  ),
//                ],
//              ),
//            ),
//            Container(
//              alignment: FractionalOffset.centerLeft,
//              child: Container(
//                  width: MediaQuery.of(context).size.width / 5,
//                  decoration: BoxDecoration(
//                      border: Border.all(color: Colors.black, width: 4)),
//                  child: BookDetailsCoverImage(
//                      books[index].id, books[index].path)),
//            ),
//          ],
//        ),
//      );
//    }

    Widget coolTile(index) {
      return GestureDetector(
        onTap:() => viewBookDetails(books[index].id),
        child: Container(
          height: MediaQuery.of(context).size.height / 5,
          decoration: new BoxDecoration(
            color: index % 2 == 0 ? Colors.white : Colors.white70,
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
          child: Row(
            children: <Widget>[
              Container(
                child: Container(
                  child: BookDetailsCoverImage(
                        books[index].id, books[index].path,MediaQuery.of(context).size.height / 5, MediaQuery.of(context).size.width/3.7),
                ),
              ),
              Container(width: MediaQuery.of(context).size.width/16,),
              Container(
                width: MediaQuery.of(context).size.width*0.55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 20.0),
                    Text(
                      books[index].title,
                      style: headerTextStyle,
                      overflow: TextOverflow.ellipsis,maxLines: 2,
                    ),
                    Container(height: 10.0),
                    Text(
                      books[index].author_sort,
                      style: subHeaderTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        height: 2.0,
                        width: 18.0,
                        color: Color(0xff00c6ff)),
                  ],
                ),
              ),
            DownloadIcon(books[index].id)],
          ),
        ),
      );
    }

    return update.searchFilter == 'title'
        ? ListView.builder(
            itemBuilder: (ctx, index) {
              return filter == null
                  ? coolTile(index)
                  : (books[index]
                          .title
                          .toLowerCase()
                          .contains(filter.toLowerCase())
                      ? coolTile(index)
                      : Container());
            },
            itemCount: books.length,
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return filter == null
                  ? coolTile(index)
                  : (books[index]
                          .title
                          .toLowerCase()
                          .contains(filter.toLowerCase())
                      ? coolTile(index)
                      : Container());
            },
            itemCount: books.length,
          );
  }
}
