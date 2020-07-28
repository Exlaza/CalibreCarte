import 'package:calibre_carte/helpers/slide_left_transition.dart';
import 'package:calibre_carte/helpers/slide_transition_route.dart';
import 'package:calibre_carte/models/publishers.dart';
import 'package:calibre_carte/models/ratings.dart';
import 'package:calibre_carte/providers/book_details_navigation_provider.dart';
import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:calibre_carte/providers/list_tile.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/widgets/details_screen_widgets/rating.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class BookDetailsText extends StatelessWidget {
  final bottomSize;
  final width;
  final bookDetails;
  final authorText;
  final Ratings rating;
  final Publishers publishers;

  BookDetailsText(this.bottomSize, this.width, this.bookDetails,
      this.authorText, this.rating, this.publishers);

  void gotoNextBook(context, refreshTile) {
    BookDetailsNavigation bn =
    Provider.of<BookDetailsNavigation>(context, listen: false);

    int currIndex = bn.index;
    bn.index = (currIndex + 1)% bn.booksList.length;

    Navigator.of(context)
        .pushReplacement(SlideRightRoute(
            page: BookDetailsScreen(
                bookId: bn.booksList[bn.index].id, refreshTile: refreshTile)))
        .then((_) {
//      print("I am now popping out of somewhere");
    });
  }

  void gotoPrevBook(context, refreshTile) {
    BookDetailsNavigation bn =
    Provider.of<BookDetailsNavigation>(context, listen: false);

    int currIndex = bn.index;
    bn.index = (currIndex - 1) % bn.booksList.length;

    Navigator.of(context)
        .pushReplacement(SlideLeftRoute(
        page: BookDetailsScreen(
            bookId: bn.booksList[bn.index].id, refreshTile: refreshTile)))
        .then((_) {
//      print("I am now popping out of somewhere");
    });

  }

  @override
  Widget build(BuildContext context) {
    ColorTheme colorTheme = Provider.of(context);
    ListTileProvider lstp = Provider.of(context, listen: false);
    BookDetailsNavigation bn =
        Provider.of<BookDetailsNavigation>(context, listen: false);
    return Column(
      children: <Widget>[
        Container(
          height: bottomSize * 0.85,
          color: colorTheme.descriptionBackground,
          child: SingleChildScrollView(
            child: Container(
              width: width,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 2, 5),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      bookDetails.title,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 19,
                          color: colorTheme.headerText),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 2, 5),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "by $authorText",
//              overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorTheme.headerText,
                        fontFamily: 'Montserrat',
//                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
//              maxLines: 2,
                    ),
                  ),
                  publishers == null
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(5, 10, 2, 5),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Publisher: ${publishers.name}",
//              overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
//                        fontStyle: FontStyle.italic,
                              fontSize: 14, color: colorTheme.subHeaderText,
                            ),
//              maxLines: 2,
                          ),
                        ),
                  bookDetails.pubdate == null
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(5, 10, 2, 20),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Date Published: ${bookDetails.pubdate.substring(0, 10)}",
//              overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
//                        fontStyle: FontStyle.italic,
                              fontSize: 14, color: colorTheme.subHeaderText,
                            ),
//              maxLines: 2,
                          ),
                        ),
                  SmoothStarRating(
                    isReadOnly: true,
                    allowHalfRating: false,
                    starCount: 5,
                    rating: rating == null ? 5 : (rating.rating / 2).toDouble(),
                    color: rating == null
                        ? Colors.grey.withOpacity(0.5)
                        : Color(0xffFED962),
                    borderColor: rating == null
                        ? Colors.grey.withOpacity(0.5)
                        : Color(0xffFFE06F),
                  ),
                ],
              ),
              // TODO: change sizes
            ),
          ),
        ),
        Container(
          height: (bottomSize * 0.15),
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => gotoPrevBook(context, lstp.refreshTile),
                child: Container(
                  width: width / 2,
                  height: (bottomSize * 0.15),
                  color: colorTheme.descriptionArrowBackground,
                  child: Icon(
                    Icons.arrow_back,
                    color: colorTheme.descriptionArrow,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => gotoNextBook(context, lstp.refreshTile),
                child: Container(
                  height: (bottomSize * 0.15),
                  width: width / 2,
                  color: colorTheme.descriptionArrowBackground,
                  child: Icon(
                    Icons.arrow_forward,
                    color: colorTheme.descriptionArrow,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
