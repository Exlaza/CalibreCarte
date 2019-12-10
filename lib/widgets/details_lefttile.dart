import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:calibre_carte/widgets/details_text.dart';
import 'package:flutter/material.dart';

class DetailsLeftTile extends StatelessWidget {
  final bookId;
  final bookDetails;
  final authorText;
  final totalHeight;

  DetailsLeftTile(
      {this.bookId, this.bookDetails, this.authorText, this.totalHeight});

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
          BookDetailsText(bottomSize, width, bookDetails, authorText),
        ],
      ),
    );
  }
}
