import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:flutter/material.dart';
class DetailsLeftTile extends StatelessWidget {
  final bookId;
  final bookDetails;
  final authorText;
  final totalHeight;
  DetailsLeftTile({this.bookId,this.bookDetails,this.authorText,this.totalHeight});
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 1.5;


    var bottomSize = totalHeight / 2;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // TODO: change sizes
          Container(
            child: BookDetailsCoverImage(
                bookId, bookDetails.path, bottomSize - 1, width),
          ),
          Container(
            height: 1,
            color: Colors.black,
            width: width,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: (bottomSize * 0.25),
                  child: Text(
                    bookDetails.title,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 20),
                    textAlign: TextAlign.left,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  height: (bottomSize * 0.25),
                  alignment: Alignment.center,
                  child: Text(
                    authorText,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontStyle: FontStyle.italic),
                    maxLines: 2,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: (bottomSize * 0.25),
                  child: Text(
                    "Date added : ${bookDetails.timestamp.substring(0, 10)}",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
                    textAlign: TextAlign.left,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  height: (bottomSize * 0.25),
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: width / 2,
                        height: (bottomSize * 0.25),
                        color: Color(0xFF002242),
                        child: Icon(
                          Icons.arrow_back,
                          color: Color(0xffFED962),
                        ),
                      ),
                      Container(
                        height: (bottomSize * 0.25),
                        width: width / 2,
                        color: Color(0xFF002242),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Color(0xffFED962),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            // TODO: change sizes

            width: width,
            height: bottomSize,
          ),
        ],
      ),
    );
  }
}
