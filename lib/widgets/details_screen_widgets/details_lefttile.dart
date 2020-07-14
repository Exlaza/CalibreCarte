import 'package:calibre_carte/models/publishers.dart';
import 'package:calibre_carte/models/ratings.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:calibre_carte/widgets/details_screen_widgets/details_text.dart';
import 'package:flutter/material.dart';

class DetailsLeftTile extends StatelessWidget {
  final bookId;
  final bookDetails;
  final authorText;
  final totalHeight;
  final Ratings rating;
  final Publishers publishers;

  DetailsLeftTile(
      {this.bookId, this.bookDetails, this.authorText, this.totalHeight,this.rating,this.publishers});

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
          BookDetailsText(bottomSize, width, bookDetails, authorText, rating,publishers),
        ],
      ),
    );
  }
}
