import 'package:flutter/material.dart';

class BookDetailsText extends StatelessWidget {
  final bottomSize;
  final width;
  final bookDetails;
  final authorText;
  BookDetailsText(this.bottomSize, this.width, this.bookDetails, this.authorText);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: (bottomSize * 0.3),
            child: Text(
              bookDetails.title,
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 20),
              textAlign: TextAlign.left,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            height: (bottomSize * 0.3),
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
            height: (bottomSize * 0.15),
            alignment: Alignment.topCenter,
            child: Row(
              children: <Widget>[
                Container(
                  width: width / 2,
                  height: (bottomSize * 0.15),
                  color: Color(0xFF002242),
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xffFED962),
                  ),
                ),
                Container(
                  height: (bottomSize * 0.15),
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
    );
  }
}
