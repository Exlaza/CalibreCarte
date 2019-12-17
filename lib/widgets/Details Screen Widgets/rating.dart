import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final rating;
  final width;

  StarRating(this.rating,this.width);

  @override
  Widget build(BuildContext context) {
    return Container(width: width,padding: EdgeInsets.all(3),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return Icon(index < rating ? Icons.star : Icons.star_border);
        }),
      ),
    );
  }
}
