import 'package:flutter/material.dart';

class BookDetailsText extends StatefulWidget {
  final bottomSize;
  final width;
  final bookDetails;
  final authorText;
  BookDetailsText(this.bottomSize, this.width, this.bookDetails, this.authorText);

  @override
  _BookDetailsTextState createState() => _BookDetailsTextState();
}

class _BookDetailsTextState extends State<BookDetailsText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: (widget.bottomSize * 0.25),
            child: Text(
              widget.bookDetails.title,
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 20),
              textAlign: TextAlign.left,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            height: (widget.bottomSize * 0.25),
            alignment: Alignment.center,
            child: Text(
              widget.authorText,
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
            height: (widget.bottomSize * 0.25),
            child: Text(
              "Date added : ${widget.bookDetails.timestamp.substring(0, 10)}",
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
              textAlign: TextAlign.left,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            height: (widget.bottomSize * 0.25),
            alignment: Alignment.topCenter,
            child: Row(
              children: <Widget>[
                Container(
                  width: widget.width / 2,
                  height: (widget.bottomSize * 0.25),
                  color: Color(0xFF002242),
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xffFED962),
                  ),
                ),
                Container(
                  height: (widget.bottomSize * 0.25),
                  width: widget.width / 2,
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

      width: widget.width,
      height: widget.bottomSize,
    );
  }
}
